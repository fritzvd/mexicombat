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
    private var healthBox;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        sprite = new Spritemap("graphics/bigsprites.png", 133, 200);
        sprite.add("idle", [4]);
        sprite.add("walk", [4,5,7,8], 12);
        sprite.play("idle");
        setHitbox(133,200);

        graphic = sprite;

        velocity = 0;
    }

    public function setHealthBox (healthBox:HealthBox)
    {
        
    }

    public function setKeysPlayer(left, right, playerNo)
    {
        type = "fighter" + playerNo;
        if (playerNo == 0){
            enemyNo = 1;
        } else {
            enemyNo = 0;
        }
        Input.define("left" + playerNo, [left]);
        Input.define("right" + playerNo, [right]);
    }

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
        }
        sprite.flipped = true;
    }

    public override function update()
    {
        handleInput();
        move();
        setAnimations();
        super.update();
    }
}