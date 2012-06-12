#include <Miniskybot.h>

const short BRIDGE_L1 = 2;
const short BRIDGE_R1 = 4; 
const short BRIDGE_E1 = 3;

const short BRIDGE_L2 = 7;
const short BRIDGE_R2 = 6; 
const short BRIDGE_E2 = 5;

Miniskybot miniskybot;

const unsigned TIME = 500; //-- (ms)

#define BUFFER_SIZE
char buffer[BUFFER_SIZE];

void setup()
{
	//-- Configuring miniskybot: adding hardware
	miniskybot.addMotor(BRIDGE_L1, BRIDGE_R1, BRIDGE_E1);
	miniskybot.addMotor(BRIDGE_L2, BRIDGE_R2, BRIDGE_E2);

	//-- Start serial connection
	Serial.begin(9600);
	Serial.println( "OK!");
	Serial.flush();
}

void loop()
{
	int velocity;

	bool flag = true;	
	while(flag)
	{
		if ( Serial.available() > 0 )
		{
			//-- Recieve the command:
			delay(20); //-- Waits for the buffer to be filled

			int data = Serial.available(); //-- Number of bytes recieved
		
			if (data > BUFFER_SIZE) //--Avoid overflow
				data = BUFFER_SIZE;

			for ( int i = 0; i < data; i++) //-- Write the data on the buffer
				buffer[i] = Serial.read(); 
			
			//-- Obtain velocity
			velocity = atoi( buffer );
					
			//-- If it doesn't recognize the command, or has received it correctly
			//-- prepare for a new command:
			Serial.flush();
			erase(buffer);

			//-- Exit the loop
			flag = false;
		}
	}
	
	//-- Set the velocity obtained via serial port on the motors
	miniskybot.motorControl( velocity, 0);
	miniskybot.motorControl( -velocity, 1);

}

//-- This erases the buffer when needed
void erase( char *buffer)
{
	for (int i; i < BUFFER_SIZE ; i++) { buffer[i] = '\0';}
}

