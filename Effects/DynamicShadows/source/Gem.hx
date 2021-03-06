package;

import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.phys.Material;

/*  
 *	About the 'userData'-field:
 *	Most things in Nape have this handy Dynamic field called 'userData' which can hold pretty much any kind of data. This can aid you in finding- or referencing this particular
 *	nape-sprite instance later, just do: body.userData.someFieldName = someValue
 *	Note: The program does not always provide you with error messages when it crashes and when Nape is involved; be sure to not refer to fields in userData that you're not
 *	sure exists.
 * 
 *	To read more about what Nape is and what it can do (and to study some interesting - and useful - Nape demos), visit: http://napephys.com/samples.html
 */

class Gem extends FlxNapeSprite
{
	private var isBeingDragged:Bool = false;
	private var lastX:Int = 0;
	private var lastY:Int = 0;
	private var lastGlitterFrame:Int = 0;
	private var dragJoint:PivotJoint;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y, null, true, true);
		loadGraphic("assets/images/gem.png", true, 16, 16);
		animation.add("glitter1", [0], 0, false);
		animation.add("glitter2", [1], 0, false);
		animation.add("glitter3", [2], 0, false);
		
		createRectangularBody(16, 16, BodyType.DYNAMIC);
		body.setShapeMaterials(Material.ice());
		
		body.userData.type = "Gem";
		
		dragJoint = new PivotJoint(FlxNapeSpace.space.world, null, Vec2.weak(), Vec2.weak());
		dragJoint.space = FlxNapeSpace.space;
		dragJoint.active = false;
		dragJoint.stiff = false;
	}
	
	override public function update(elapsed:Float):Void
	{
		// For the glitter effect
		if (Std.int(x) != lastX || Std.int(y) != lastY)
		{
			lastGlitterFrame = ++lastGlitterFrame % 3;
			
			if (lastGlitterFrame == 0)
			{
				animation.play("glitter1");
			}
			else if (lastGlitterFrame == 1)
			{
				animation.play("glitter2");
			}
			else if (lastGlitterFrame == 2)
			{
				animation.play("glitter3");
			}
		}
		
		lastX = Std.int(x);
		lastY = Std.int(y);
		
		if (FlxG.mouse.justPressed && FlxG.mouse.getWorldPosition().inCoords(x, y, width, height)) 
		{
			var mousePoint = Vec2.get(FlxG.mouse.x, FlxG.mouse.y);
			
			dragJoint.body2 = body;
            dragJoint.anchor2.set(body.worldPointToLocal(mousePoint, true));
            dragJoint.active = true;
			
			mousePoint.dispose();
		}
		
		if (!FlxG.mouse.pressed) 
		{
			dragJoint.active = false;
		}
		
		if (dragJoint.active)
		{
			dragJoint.anchor1.setxy(FlxG.mouse.x, FlxG.mouse.y);
		}
		
		super.update(elapsed);
	}
	
}