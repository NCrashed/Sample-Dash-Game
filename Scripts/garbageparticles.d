module garbageparticles;
import core.gameobject;
import utility.input, utility.output, utility.time;
import graphics;
import components;
import gl3n.linalg;

import std.random, std.math, std.parallelism, std.stdio;

shared class Particle : GameObject
{
	float velocity;
	float theta;

	this(float theta, float velocity)
	{
		this.velocity = velocity;
		this.theta = theta;
		super();
	}

	override void onUpdate()
	{
		float d = sqrt( pow( (cast()(transform.position)).x,2) + pow((cast()(transform.position)).y,2) );
		if( d > 100 || d < 40 )
		{
			velocity = -velocity;
		}

		d += velocity * Time.deltaTime;
		transform.position = vec3(d*cos(theta), d*sin(theta), -80);//d*cos(theta);
	
		
		transform.updateMatrix();
		
	}

	override void onDraw()
	{

	}

	override void onShutdown() { }

	override void onCollision( GameObject other ) { }
}

shared class ParticleEmitter : GameObject
{

	static int numParticles = 100;
	shared GameObject[] particles;
		
	override void onUpdate()
	{
		// init particles if they aren't
		if( particles.length == 0 )
		{
			float delta = (3.14159f*2.0f) / (cast(float)numParticles);
			float theta = 0.0f;
			for( int i = 0; i < numParticles; i++ )
			{
				particles ~= new shared Particle(theta, 10);
				particles[i].transform.position = vec3( 80*cos( theta ),
													80*sin( theta ), -80 );
				particles[i].light = new shared PointLight( vec3(1,1,1), 15 );
				particles[i].light.owner = particles[i];
				particles[i].transform.updateMatrix();
				theta += delta;
			}
		}
		else // update particles otherwise
		{
			foreach( p; parallel( cast()particles ) )
			{
				p.onUpdate();
			}
		}
	}

	override void onDraw()
	{
		foreach(p; particles)
		{
			p.draw();
		}
	}

	override void onShutdown() { }

	override void onCollision( GameObject other ) { }
}
