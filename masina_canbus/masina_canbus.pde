#include <WaspCAN.h>



// ID numbers
#define IDWAITED 200
#define OWNID 100
#define CAN_speed 500

void setup()
{
  // put your setup code here, to run once:
  // Initialize the USB
  USB.ON();
  delay(100);

  // Let's open the bus. Remember the input parameter:
  // 1000: 1Mbps
  // 500: 500Kbps  <--- Most frequently used
  // 250: 250Kbp
  // 125: 125Kbps
  CAN.ON(CAN_speed);
  USB.print("CAN Bus initialized at ");
  USB.print(CAN_speed);
  USB.println(" KBits/s");


}


void loop()
{

  // Read the value of the Vehicle Speed
  int vehicleSpeed = CAN.getVehicleSpeed();

  // Read the value of RPM of the engine
  int engineRPM = CAN.getEngineRPM();

  // Read the engine fuel rate
  int engineFuelRate = CAN.getEngineFuelRate();

  // Get the fuel level
  int fuelLevel = CAN.getFuelLevel();

  // Get the throttle position
  int throttlePosition = CAN.getThrottlePosition();

  //Get the fuel pressure value
  int fuelPressure = CAN.getFuelPressure();


  USB.println(F("<============================================>"));
  USB.print(F("\tVehicle Speed =>  "));
  USB.print(vehicleSpeed);
  USB.println("  Km / h");

  USB.print(F("\tEngine RPM =>  "));
  USB.print(engineRPM);
  USB.println("  RPM");

  USB.print(F("\tEngine Fuel Rate =>  "));
  USB.print(engineFuelRate);
  USB.println("  L/h");

  USB.print(F("\tFuel Level =>  "));
  USB.print(fuelLevel);
  USB.println("  %");

  USB.print(F("\tThrottle Position =>  "));
  USB.print(throttlePosition);
  USB.println(" % ");

  USB.print(F("\tFuel Pressure =>  "));
  USB.print(fuelPressure);
  USB.println("  KPa");

  USB.println(F("<============================================>"));

  USB.println();

  delay(1000);



}


/*
 * functii disponibile pe can bus 
    uint16_t getEngineLoad();
    uint16_t getEngineCoolantTemp();
    uint16_t getFuelPressure();
    uint16_t getIntakeMAPressure();
    uint16_t getEngineRPM();
    uint16_t getVehicleSpeed();
    uint16_t getTimingAdvance();
    uint16_t getIntankeAirTemp();
    uint16_t getMAFairFlowRate();
    uint8_t getThrottlePosition();
    uint8_t getFuelLevel();
    uint8_t getBarometricPressure();
    uint16_t getEngineFuelRate();
 
 */



