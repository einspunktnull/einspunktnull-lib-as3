package net.einspunktnull.ai.steeringbehaviors.display.moveable
{
	import net.einspunktnull.ai.steeringbehaviors.display.obstacle.Circle;
	import net.einspunktnull.data.ds.Vector2D;

	/**
	 * @author Albrecht Nitsche
	 */
	public class SteeredVehicle extends Vehicle
	{
		private var _maxForce : Number = 1;
		private var _steeringForce : Vector2D;
		private var _arrivalThreshold : Number = 100;
		private var _wanderDistance : Number = 0;
		private var _wanderRadius : Number = 5;
		private var _wanderAngle : Number = 10;
		private var _wanderRange : Number = 1;
		private var _pathIndex : int = 0;
		private var _pathThreshold : Number = 20;
		private var _avoidDistance : Number = 300;
		private var _avoidBuffer : Number = 20;
		private var _inSightDist : Number = 200;
		private var _tooCloseDist : Number = 60;

		public function SteeredVehicle()
		{
			_steeringForce = new Vector2D();
			super();
		}


		override public function update() : void
		{
			_steeringForce.truncate(_maxForce);
			_steeringForce = _steeringForce.divide(_mass);
			_velocity = _velocity.add(_steeringForce);
			_steeringForce = new Vector2D();
			super.update();
		}


		/********************************
		 * 	BEHAVIOURS
		 ********************************/


		public function seek(target : Vector2D) : void
		{
			_steeringForce = _steeringForce.add(getFleeOrSeekForce(target));
		}

		public function flee(target : Vector2D) : void
		{
			_steeringForce = _steeringForce.subtract(getFleeOrSeekForce(target));
		}

		private function getFleeOrSeekForce(target : Vector2D) : Vector2D
		{
			var desiredVelocity : Vector2D = target.subtract(_position);
			desiredVelocity.normalize();
			desiredVelocity = desiredVelocity.multiply(_maxSpeed);
			return desiredVelocity.subtract(_velocity);
		}

		public function arrive(target : Vector2D) : void
		{
			var desiredVelocity : Vector2D = target.subtract(_position);
			desiredVelocity.normalize();

			var dist : Number = _position.distance(target);
			if (dist > _arrivalThreshold)
			{
				desiredVelocity = desiredVelocity.multiply(_maxSpeed);
			}
			else
			{
				desiredVelocity = desiredVelocity.multiply(_maxSpeed * dist / _arrivalThreshold);
			}

			var force : Vector2D = desiredVelocity.subtract(_velocity);
			_steeringForce = _steeringForce.add(force);
		}

		public function pursue(target : Vehicle) : void
		{
			var predictedTarget : Vector2D = target.position.add(getPursueOrEvadeTargetVelocityDistance(target));
			seek(predictedTarget);
		}

		public function evade(target : Vehicle) : void
		{
			var predictedTarget : Vector2D = target.position.subtract(getPursueOrEvadeTargetVelocityDistance(target));
			flee(predictedTarget);
		}

		private function getPursueOrEvadeTargetVelocityDistance(target : Vehicle) : Vector2D
		{
			var lookAheadTime : Number = position.distance(target.position) / _maxSpeed;
			return target.velocity.multiply(lookAheadTime);
		}

		public function wander() : void
		{
			var center : Vector2D = velocity.clone().normalize().multiply(_wanderDistance);
			var offset : Vector2D = new Vector2D(0);
			offset.length = _wanderRadius;
			offset.angle = _wanderAngle;
			_wanderAngle += Math.random() * _wanderRange - _wanderRange * .5;
			var force : Vector2D = center.add(offset);
			_steeringForce = _steeringForce.add(force);
		}

		public function avoid(circles : Array) : void
		{
			for (var i : int = 0; i < circles.length; i++)
			{
				var circle : Circle = circles[i] as Circle;
				var heading : Vector2D = _velocity.clone().normalize();

				// vector between circle and vehicle:
				var difference : Vector2D = circle.position.subtract(_position);
				var dotProd : Number = difference.dotProduct(heading);

				// if circle is in front of vehicle...
				if (dotProd > 0)
				{
					// vector to represent "feeler" arm
					var feeler : Vector2D = heading.multiply(_avoidDistance);
					// project difference vector onto feeler
					var projection : Vector2D = heading.multiply(dotProd);
					// distance from circle to feeler
					var dist : Number = projection.subtract(difference).length;

					// if feeler intersects circle (plus buffer),
					// and projection is less than feeler length,
					// we will collide, so need to steer
					if (dist < circle.radius + _avoidBuffer && projection.length < feeler.length)
					{
						// calculate a force +/- 90 degrees from vector to circle
						var force : Vector2D = heading.multiply(_maxSpeed);
						force.angle += difference.sign(_velocity) * Math.PI / 2;

						// scale this force by distance to circle.
						// the further away, the smaller the force
						force = force.multiply(1.0 - projection.length / feeler.length);

						// add to steering force
						_steeringForce = _steeringForce.add(force);

						// braking force
						_velocity = _velocity.multiply(projection.length / feeler.length);
					}
				}
			}
		}


		public function followPath(path : Array, loop : Boolean = false) : void
		{
			var wayPoint : Vector2D = path[_pathIndex];
			if (wayPoint == null) return;
			if (_position.distance(wayPoint) < _pathThreshold)
			{
				if (_pathIndex >= path.length - 1)
				{
					if (loop)
					{
						_pathIndex = 0;
					}
				}
				else
				{
					_pathIndex++;
				}
			}
			if (_pathIndex >= path.length - 1 && !loop)
			{
				arrive(wayPoint);
			}
			else
			{
				seek(wayPoint);
			}
		}

		public function flock(vehicles : Array) : void
		{
			var averageVelocity : Vector2D = _velocity.clone();
			var averagePosition : Vector2D = new Vector2D();
			var inSightCount : int = 0;
			for (var i : int = 0; i < vehicles.length; i++)
			{
				var vehicle : Vehicle = vehicles[i] as Vehicle;
				if (vehicle != this && inSight(vehicle))
				{
					averageVelocity = averageVelocity.add(vehicle.velocity);
					averagePosition = averagePosition.add(vehicle.position);
					if (tooClose(vehicle)) flee(vehicle.position);
					inSightCount++;
				}
			}
			if (inSightCount > 0)
			{
				averageVelocity = averageVelocity.divide(inSightCount);
				averagePosition = averagePosition.divide(inSightCount);
				seek(averagePosition);
				_steeringForce.add(averageVelocity.subtract(_velocity));
			}
		}

		public function inSight(vehicle : Vehicle) : Boolean
		{
			if (_position.distance(vehicle.position) > _inSightDist) return false;
			var heading : Vector2D = _velocity.clone().normalize();
			var difference : Vector2D = vehicle.position.subtract(_position);
			var dotProd : Number = difference.dotProduct(heading);

			if (dotProd < 0) return false;
			return true;
		}

		public function tooClose(vehicle : Vehicle) : Boolean
		{
			return _position.distance(vehicle.position) < _tooCloseDist;
		}


		/********************************
		 * 	GETTER / SETTER
		 ********************************/

		public function get maxForce() : Number
		{
			return _maxForce;
		}

		public function set maxForce(maxForce : Number) : void
		{
			_maxForce = maxForce;
		}

		public function get arrivalThreshold() : Number
		{
			return _arrivalThreshold;
		}

		public function set arrivalThreshold(arrivalThreshold : Number) : void
		{
			_arrivalThreshold = arrivalThreshold;
		}

		public function get wanderDistance() : Number
		{
			return _wanderDistance;
		}

		public function set wanderDistance(wanderDistance : Number) : void
		{
			_wanderDistance = wanderDistance;
		}

		public function get wanderRadius() : Number
		{
			return _wanderRadius;
		}

		public function set wanderRadius(wanderRadius : Number) : void
		{
			_wanderRadius = wanderRadius;
		}

		public function get wanderAngle() : Number
		{
			return _wanderAngle;
		}

		public function set wanderAngle(wanderAngle : Number) : void
		{
			_wanderAngle = wanderAngle;
		}

		public function get wanderRange() : Number
		{
			return _wanderRange;
		}

		public function set wanderRange(wanderRange : Number) : void
		{
			_wanderRange = wanderRange;
		}

		public function get avoidDistance() : Number
		{
			return _avoidDistance;
		}

		public function set avoidDistance(avoidDistance : Number) : void
		{
			_avoidDistance = avoidDistance;
		}

		public function get avoidBuffer() : Number
		{
			return _avoidBuffer;
		}

		public function set avoidBuffer(avoidBuffer : Number) : void
		{
			_avoidBuffer = avoidBuffer;
		}

	}
}
