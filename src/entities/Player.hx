package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import entities.HealthBox;
import com.haxepunk.graphics.Image;


class Player extends Entity
{
    private var playerNo:Int;
    private var enemyNo:Int;
    private var velocity:Float;
    private var acceleration:Float;
    private var sprite:Spritemap;
    private var health:Int;
    private var healthBox:HealthBox;
    private var enemyX:Float;

    public var fightingState:String;
    public var enemyFightingState:String;

    #if android 
    // Width for touch screen
    private var maxX:Float;
    private var minX:Float;
    private var halfX:Float;
    private var halfY:Float;
    #end

    public function new(x:Float, y:Float)
    {
        super(x, y);

        sprite = new Spritemap("graphics/bigsprites.png", 30, 64);
        sprite.scale = 2.0;
        sprite.add("idle", [0, 1], 6);
        sprite.add("walk", [2,3,2,4], 6);
        sprite.add("punch", [5,6,1], 6);
        sprite.add("kick", [1,2], 6);
        sprite.play("idle");
        setHitbox(30,64);
        health = 100;

        fightingState = '';

        graphic = sprite;
        // graphic = Image.createRect(130, 200);

        velocity = 0;
    }

    public function setPlayer(fighterName:String)
    {
        sprite = new Spritemap("graphics/fighters/"+ fighterName + ".png", 30, 64);
    }

    public function setHealthBox (hBox:HealthBox)
    {
        healthBox = hBox;
    }

    public function setEnemyX(enX:Float, enFightingState:String)
    {   
        enemyX = enX;
        enemyFightingState = enFightingState;
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

#if !android
    private function handleInput()
    {
        acceleration = 0;
        if (Input.check("left" + playerNo))
        {
            acceleration = -2;
        }
        if (Input.check("right" + playerNo))
        {
            acceleration = 2;
        }
        if (Input.check("kick" + playerNo))
        {
            fightingState = "punching";
        }
        if (Input.check("punch" + playerNo))
        {
            fightingState = "kicking";
        }
    }
#end

#if android
    private function handleTouch(touch:com.haxepunk.utils.Touch) {
        if (playerNo == 0) {
            maxX = HXP.width / 2;
            minX = 0;
            halfX = HXP.width / 4;
        } else {
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
        if (enemyFightingState == 'punching'){
            health -= 1;            
        }
        // if (enemyFightingState == 'kicking'){
        //     health = -20;            
        // }        
        // // HXP.console.log([e]);
        // // HXP.console.log(["PIET"]);
        if (health < 0) {
               health = 0;
               fightingState = "dead";
        //     scene.remove(this);
        }

        return true;
    }

    private function setAnimations()
    {
        if (velocity == 0)
        {
            sprite.play("idle");
        } else if (velocity > 0 || velocity < 0) {
            sprite.play("walk");
        }

        if (this.x > enemyX) {
            sprite.flipped = true;        
        } else {
            sprite.flipped = false;
        }

        if (fightingState == 'punching') {
            sprite.play("punch");
        }
        healthBox.health = health;


    }

    public override function update()
    {
        #if !android
        handleInput();
        #end
        #if android
        Input.touchPoints(handleTouch);
        #end
        move();
        setAnimations();

        super.update();
    }
}