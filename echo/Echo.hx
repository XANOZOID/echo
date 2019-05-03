package echo;

import haxe.ds.Either;
import echo.Body;
import echo.Listener;
import echo.Collisions;
import echo.World;
import echo.data.Types;
import echo.data.Options;
import echo.util.BodyOrBodies;

@:expose
/**
 * Echo acts as the root Class for `Body`, `Group`, and `World`. It also holds helpful utility methods to help streamline the creation and management of Physics Simulations.
 */
class Echo {
  /**
   * Shortcut for creating a new `World`
   * @param options Options for the new `World`
   * @return World
   */
  public static function start(options:WorldOptions):World return new World(options);
  /**
   * Shortcut for creating a new `Body` and adding it to the `World`
   * @param world the `World` to add the `Body` to
   * @param options Options for the new `Body`
   * @return Body
   */
  public static function make(world:World, options:BodyOptions):Body return world.add(new Body(options));
  /**
   * Shortcut for creating a new `Listener` for a set of Bodies in the `World`.
   * @param world the `World` to add the `Listener` to
   * @param a The first `Body` or `Group` to collide against
   * @param b The second `Body` or `Group` to collide against
   * @param options Options to define the Listener's behavior
   * @return Listener
   */
  public static function listen(world:World, ?a:BodyOrBodies, ?b:BodyOrBodies, ?options:ListenerOptions):Listener {
    if (a == null) return b == null ? world.listeners.add(world.members, world.members, options) : world.listeners.add(b, b, options);
    if (b == null) return world.listeners.add(a, a, options);
    return world.listeners.add(a, b, options);
  }
  /**
   * Steps a `World` forward.
   * @param world
   * @param dt
   */
  public static function step(world:World, dt:Float) {
    // TODO: Save World State to History
    var fdt = dt / world.iterations;
    // Apply Gravity
    world.for_each(member -> {
      member.acceleration.x += world.gravity.x * member.gravity_scale;
      member.acceleration.y += world.gravity.y * member.gravity_scale;
    });
    for (i in 0...world.iterations) {
      Physics.step(world, fdt);
      Collisions.query(world);
      Physics.separate(world, fdt);
      Collisions.notify(world);
    }
    // Reset acceleration
    world.for_each(member -> member.acceleration.set(0, 0));
  }
  /**
   * TODO: Undo a World's last step
   * @param world
   * @return World
   */
  public static function undo(world:World):World {
    return world;
  }
  /**
   * TODO: Redo a World's last step
   * @param world
   * @return World
   */
  public static function redo(world:World):World {
    return world;
  }
  /**
   * TODO: Perform a collision check.
   * @param a
   * @param b
   * @param options
   */
  public static function collide(a:Echo, b:Echo, ?options:ListenerOptions) {}
}
