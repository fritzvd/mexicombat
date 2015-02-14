package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.masks.Circle;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.Mask;
import com.haxepunk.masks.Pixelmask;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

import entities.HealthBox;
import entities.AIPlayer;


class Player extends Entity
{
    private var playerNo:Int;
    private var enemyNo:Int;
    private var velocity:Float;
    private var acceleration:Float;
    public var sprite:Spritemap;
    public var health:Int;
    private var healthBox:HealthBox;
    private var scaling:Float;
    private var scalint:Int;

    public var fightingState:String;
    public var enemyFightingState:String;
    private var fightingStateCounter:Float;
    private var hitboxHeight:Int;
    private var hitboxWidth:Int;

    private var oldPlays:Int;
    private var main:Main;

    private var enemy:Player;
    private var maskOffset:Int;
    public var attackHitbox:Hitbox;
    public var impact:Bool;
    public var clamp:Bool;


    #if mobile 
    // Width for touch screen
    private var maxX:Float;
    private var minX:Float;
    private var halfX:Float;
    private var halfY:Float;
    public var singlePlayer:Bool;
    #end

    public function new(x:Float, y:Float)
    {
        super(x, y, mask);

        health = 100;

        fightingState = '';
        fightingStateCounter = 0;

        velocity = 0;
        main = cast(HXP.engine, Main);
        oldPlays = main.plays;

    }

    private function cback()
    {
        if (sprite.complete) {
            fightingState = "idle";
            sprite.play("idle");
            impact = false;       
        }
    }

    public function setPlayer(fighterName:String)
    {
        scaling = main.scaling;
        hitboxHeight = Math.round(340 * scaling);
        hitboxWidth = Math.round(120 * scaling);
        // sprite = new Spritemap("graphics/fighters/"+ fighterName + ".png", 80, 80, cback);
        sprite = new Spritemap("graphics/fighters/"+ fighterName + ".png", 256, 300, cback);
		sprite.smooth = false;
        // not picked up?
        sprite.scale = 1.25 * scaling;
        sprite.add("idle", [0, 1, 2, 3], 12);
        sprite.add("walk", [20, 21, 22, 23, 24], 12);
        sprite.add("kick", [10, 11, 12, 13, 14], 12, false);
        sprite.add("punch", [5, 6, 7], 12, false);
        sprite.add("dead", [0], 12);
        sprite.add("impact", [15, 16, 17], 12, false);
        sprite.play("idle");
        setHitbox(hitboxWidth, hitboxHeight);
        graphic = sprite;
        layer = -1;
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
        // er
        // w
        //
        Input.define("left" + playerNo, [left]);
        Input.define("right" + playerNo, [right]);
        Input.define("punch" + playerNo, [punch]);
        Input.define("kick" + playerNo, [kick]);
    }

#if !mobile
    public function handleInput()
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
        }
        if (Input.pressed("kick" + playerNo))
        {
            fightingState = "kicking";

        }
    }
#end

#if mobile
    public function handleTouch(touch:com.haxepunk.utils.Touch) {
        if (singlePlayer) {
            maxX = HXP.width / 2;
            minX = 0;
            halfX = HXP.width / 4;
            // if (touch.sceneX > minX && touch.sceneX < maxX) {
                // move or fight
                // if (touch.sceneY > halfY){
                    // forward backward
                    if (touch.sceneX < halfX) {
                        acceleration = -2;
                        fightingState = "walking";
                    } else if ((touch.sceneX > halfX) && 
                        (touch.sceneX < maxX)) {
                        acceleration = 2;
                        fightingState = "walking";
                    }
                // } 
                if (touch.sceneX > maxX) {                 
                    if (touch.sceneX < halfX * 3) {
                        fightingState = "punching";
                    } else if (touch.sceneX > halfX * 3) {
                        fightingState = "kicking";
                    }
                }
            // }
        } else {
            if (playerNo == 0) {
                maxX = HXP.width / 2;
                minX = 0;
                halfX = HXP.width / 4;
            } else if (playerNo == 1){
                maxX = HXP.width;
                minX = HXP.width / 2;
                halfX = (HXP.width / 4) * 3;
            }
            halfY = HXP.height / 2;
            // right side of screen or left depending on player
            if (touch.sceneX > minX && touch.sceneX < maxX) {
                // move or fight
                // forward backward
                var oneEighth = HXP.width / 4 / 2;
                var halfwayhalfX = minX + oneEighth;
                if ((touch.sceneX > halfwayhalfX) && (
                    touch.sceneX < halfX)) {
                    acceleration = 2;
                }
                if (touch.sceneX < halfwayhalfX) {
                    acceleration = -2;
                }
                if (touch.sceneX > halfX) {
                    if (touch.sceneX < halfX + oneEighth) {
                        fightingState = "punching";
                    } else if (touch.sceneX > halfX + oneEighth) {
                        fightingState = "kicking";
                    }
                }
            }   
        }
        
    }
#end

    private function move()
    {
        if (!this.clamp) {
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

            moveBy(velocity, 0, "fighter" + enemyNo, true);
        }
    }

    public function getfightingState()
    {
        return fightingState;
    }

    public override function moveCollideX(e:Entity)
    {   
        return true;
    }

    private function setAnimations()
    {
        
        if (this.x > enemy.x) {
            sprite.flipped = true;
            maskOffset = Math.round(110 * scaling);
            if (scaling == 1) {
                maskOffset = 110;
            }            
        } else {
            sprite.flipped = false;
            maskOffset = Math.round(110 * scaling);
            if (scaling == 1) {
                maskOffset = 110;
            }
        }
        if (velocity == 0 && (fightingState == "walking" || fightingState == ""))
        {
            fightingState = "idle";
            mask = new Hitbox(hitboxWidth, hitboxHeight, maskOffset, 0);
            // mask.x = maskOffset;
        } else if ((velocity > 0 || velocity < 0) && (fightingState == "idle" || fightingState == "")) {
            fightingState = "walking";
            mask = new Hitbox(hitboxWidth, hitboxHeight, maskOffset, 0);
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
            case "hit":
            sprite.play("impact");
            case "idle":
            sprite.play("idle");
            case "walking":
            sprite.play("walk");
        }

        healthBox.health = health;
   }

    private function checkFightingState()
    {
        if (fightingState == 'punching' || fightingState == 'kicking' && health > 0){
            var attackOffset:Int = 0;
            if (this.x > enemy.x) {
                attackOffset = Math.round(50 * scaling);
                if (scaling == 1) {
                attackOffset = 50;
                }
            } else {
                attackOffset = Math.round(230 * scaling);
                if (scaling == 1) {
                attackOffset = 230;
                }
            }

            attackHitbox = new Circle(Math.round(35 * scaling), attackOffset, Math.round(35 * scaling));
            mask = attackHitbox;
            if (collideWith(enemy, x, y) == enemy) {
                // var ec:EmitController = scene.add(new EmitController());
                // ec.impact(x + width / 2, y + 60 * scaling);
                // scene.remove(impact);
                enemy.impact = true;
                enemy.y -= 15 * scaling;
                if (!clamp) {
                    if (enemy.sprite.flipped) {
                        enemy.x += 10;
                    } else {
                        enemy.x -= 10;
                    }
                }
                enemy.fightingState = "hit";
                enemy.health -= 1;
            } else {
                enemy.fightingState = "";
                enemy.impact = false;
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
        super.update();
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
    }
}
