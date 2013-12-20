package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.masks.Circle;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

import entities.HealthBox;

class Player extends Entity
{
    private var playerNo:Int;
    private var enemyNo:Int;
    private var velocity:Float;
    private var acceleration:Float;
    private var sprite:Spritemap;
    public var health:Int;
    private var healthBox:HealthBox;

    public var fightingState:String;
    public var enemyFightingState:String;
    private var fightingStateCounter:Float;
    // public var attackHitbox:Hitbox;

    private var oldPlays:Int;
    private var main:Main;

    private var enemy:Player;
    public var attackHitbox:Hitbox;

    #if mobile 
    // Width for touch screen
    private var maxX:Float;
    private var minX:Float;
    private var halfX:Float;
    private var halfY:Float;
    #end

    public function new(x:Float, y:Float)
    {
        var mask = new Hitbox(100,200);
        super(x, y, mask);

        health = 100;

        fightingState = '';
        fightingStateCounter = 0;

        velocity = 0;
        main = cast(HXP.engine, Main);
        oldPlays = main.plays;
    }

    public function setPlayer(fighterName:String)
    {
        sprite = new Spritemap("graphics/fighters/"+ fighterName + ".png", 100, 200);
        sprite.scale = 1.0;
        sprite.add("idle", [0], 6);
        sprite.add("walk", [7,1,2,3,5,6], 10);
        sprite.add("punch", [12,13,14,15], 10);
        sprite.add("kick", [8,9,10,11], 10);
        sprite.add("dead", [0], 12);
        sprite.play("idle");
        setHitbox(30, 200);
        graphic = sprite;
    }

    public function setHealthBox (hBox:HealthBox)
    {
        healthBox = hBox;
    }

    public function setEnemy(en:Player, no:Int)
    {   
        enemy = en;
        enemyNo = no;  
    }

    public function setKeysPlayer(left, right, punch, kick, player)
    {
        playerNo = player;
        type = "fighter" + playerNo;
        if (playerNo == 0){
            enemyNo = 1;
        } else {
            enemyNo = 0;
        }
        Input.define("left" + playerNo, [left]);
        Input.define("right" + playerNo, [right]);
        Input.define("punch" + playerNo, [punch]);
        Input.define("kick" + playerNo, [kick]);
    }

#if !mobile
    private function handleInput()
    {
        // acceleration = 0;
        if (Input.check("left" + playerNo))
        {
            acceleration = -2;
        }
        if (Input.check("right" + playerNo))
        {
            acceleration = 2;
        }
        if (Input.pressed("punch" + playerNo))
        {
            fightingState = "punching";
            // setHitbox(30,64);
        }
        if (Input.pressed("kick" + playerNo))
        {
            fightingState = "kicking";

        }
    }
#end

#if mobile
    private function handleTouch(touch:com.haxepunk.utils.Touch) {
        if (playerNo == 0) {
            maxX = HXP.width / 2;
            minX = 0;
            halfX = HXP.width / 4;
        } else if (playerNo == 1){
            maxX = HXP.width;
            minX = HXP.width / 2;
            halfX = HXP.width / 4 * 3;
        }
        halfY = HXP.height / 2;
        // right side of screen or left depending on player
        if (touch.sceneX > minX && touch.sceneX < maxX) {
            // move or fight
            if (touch.sceneY > halfY){
                // forward backward
                if (touch.sceneX < halfX) {
                    acceleration = -2;
                } else if (touch.sceneX > halfX) {
                    acceleration = 2;
                }
            } else if (touch.sceneY < halfY) {                
                if (touch.sceneX < halfX) {
                    fightingState = "punching";
                } else if (touch.sceneX > halfX) {
                    fightingState = "kicking";
                }
            }
        }
    }
#end

    private function move()
    {
        velocity += acceleration;
        if (Math.abs(velocity) > 5) {
            velocity = 5 * HXP.sign(velocity);
        }
        if (velocity < 0) {
        velocity = Math.min(velocity + 0.4, 0);
        }
         else if (velocity > 0) {
        velocity = Math.max(velocity - 0.4, 0);
        }

        moveBy(velocity, 0, "fighter" + enemyNo);
    }

    public function getfightingState()
    {
        return fightingState;
    }

    public override function moveCollideX(e:Entity)
    {   
        if (fightingState == 'punching' || fightingState == 'kicking'){
            if (e.type == "fighter" + enemyNo) 
            {
                if (enemy == null)
                {
                    enemy = cast(e, Player);
                    if (fightingState == 'punching')
                    {
                        enemy.health -= 1;                      
                    }
                    if (fightingState == 'kicking')
                    {
                        enemy.health -= 2;                      
                    }
                }
            }    
        } else if (enemyFightingState != 'dead') {
            if (enemyFightingState == 'punching')
            {
                health -= 1;
            }
            if (enemyFightingState == 'kicking')
            {
                health -= 2;
            }
        }
        // if (enemyFightingState == 'kicking'){
        //     health = -20;            
        // }        
        // // HXP.console.log([e]);
        // // HXP.console.log(["PIET"]);


        return true;
    }

    private function setAnimations()
    {
        
        if (this.x > enemy.x) {
            sprite.flipped = true;        
        } else {
            sprite.flipped = false;
        }

        if (velocity == 0 && fightingState == "")
        {
            sprite.play("idle");
        } else if ((velocity > 0 || velocity < 0) && (fightingState == "")) {
            sprite.play("walk");
        }

        switch(fightingState)
        {
            case "kicking":
            sprite.play("kick");
            case "punching":
            sprite.play("punch");
            case "dead":
            sprite.play("dead");
            sprite.angle += 10;
        }


        // trace(sprite.name);
        healthBox.health = health;

        if (this.x > HXP.screen.width) {
            this.x  = 0;
        } else if (this.x < -20) {
            this.x  = HXP.screen.width - 30;
        }

    }

    private function checkFightingState()
    {
        if (fightingState == 'punching' || fightingState == 'kicking' && health > 0){
            // attackHitbox = new Hitbox(300,30, Std.int(this.x + 110), Std.int(this.y + 20));
            // attackHitbox.parent = this; 
            attackHitbox = new Circle(30, 30, 160);
            // trace(this.mask);
            // if (enemy == null) { return;}
            if (this.mask.collide(enemy.mask)) {
                trace('wiiehaaa');
            }
            fightingStateCounter += HXP.elapsed;
            if (fightingStateCounter > 0.5) {
                fightingState = "";
                // attackHitbox = null;
                fightingStateCounter = 0;
            }
        }
        if (health <= 0) {
               health = 0;
               fightingState = "dead";
               if (oldPlays == main.plays) {
                main.plays = oldPlays + 1;
               }
        }
    }

    public override function update()
    {
        acceleration = 0;
        #if !mobile
        handleInput();
        #end
        #if mobile
        Input.touchPoints(handleTouch);
        #end
        move();
        checkFightingState();
        setAnimations();
        super.update();
    }
}
