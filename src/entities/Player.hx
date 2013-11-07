package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import entities.HealthBox;

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

    #if android 
    // Width for touch screen
    private var maxX:Float;
    private var minX:Float;
    private var halfX:Float;
    #end

    public function new(x:Float, y:Float)
    {
        super(x, y);

        sprite = new Spritemap("graphics/bigsprites.png", 133, 195);
        sprite.add("idle", [3]);
        sprite.add("walk", [3,4,5,4], 12);
        sprite.play("idle");
        setHitbox(133,50);

        graphic = sprite;

        velocity = 0;
    }

    public function setHealthBox (hBox:HealthBox)
    {
        healthBox = hBox;
    }

    public function setEnemyX(enX:Float)
    {   
        enemyX = enX;
    }

    public function setKeysPlayer(left, right, player)
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
    }
#end

#if android
    private function handleTouch(touch:com.haxepunk.utils.Touch) {
        if (playerNo == 0) {
            maxX = width / 2;
            minX = 0;
            halfX = width / 4;
        } else {
            maxX = width;
            minX = width / 2;
            halfX = width / 4 * 3;
        }
        if (touch.sceneX > minX && touch.sceneX < maxX) {
            if (touch.sceneX < halfX) {
                acceleration = -2;
            } else if (touch.sceneX > halfX) {
                acceleration = 2;
            }
        }
    }
#end

    private function move()
    {
        velocity += acceleration;
        if (Math.abs(velocity) > 5)
        {
            velocity = 5 * HXP.sign(velocity);
        }
        if (velocity < 0)
         {
        velocity = Math.min(velocity + 0.4, 0);
         }
         else if (velocity > 0)
         {
        velocity = Math.max(velocity - 0.4, 0);
         }

        moveBy(velocity, 0, "fighter" + enemyNo);
    }

    public override function moveCollideX(e:Entity)
    {
        health -= 2;
        // healthBox.updateHealth(health);
        if (health < 0) {
            scene.remove(this);
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

        if (this.x < enemyX){
            sprite.flipped = true;        
        } else {
            sprite.flipped = false;
        }
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