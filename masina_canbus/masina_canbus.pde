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

  // USB.println(F("<============================================>"));

  // USB.println();
  //--------------------------------------------------------------------------------------------------------------------------

  USB.print(F("\tVehicle FuelLevel =>  "));
  USB.print(  CAN.getFuelLevel()  );
  USB.println("  Km / h");

  USB.print(F("\tEngine MAFairFlowRate =>  "));
  USB.print(CAN.getMAFairFlowRate() );
  USB.println("  RPM");

  USB.print(F("\tEngine IntankeAirTemp =>  "));
  USB.print(CAN.getIntankeAirTemp() );
  USB.println("  L/h");

  USB.print(F("\t IntakeMAPressure =>  "));
  USB.print(CAN.getIntakeMAPressure() );
  USB.println("  %");

  USB.print(F("\t  EngineCoolantTemp =>  "));
  USB.print( CAN.getEngineCoolantTemp() );
  USB.println(" % ");

  USB.print(F("\t  EngineLoad =>  "));
  USB.print( CAN.getEngineLoad()  );
  USB.println("  KPa");

  USB.println(F("<============================================>"));

  USB.println();


  delay(5000);



}


/*
   functii disponibile pe can bus
    uint16_t getEngineLoad();
  x uint16_t getEngineCoolantTemp();
  x  uint16_t getIntakeMAPressure();
    uint16_t getTimingAdvance();
  x  uint16_t getIntankeAirTemp();
  x  uint16_t getMAFairFlowRate();
  x  uint8_t getThrottlePosition();
  x  uint8_t getFuelLevel();
  x  uint8_t getBarometricPressure();
  x  uint16_t getEngineFuelRate();
    x  uint16_t getEngineRPM();
  x  uint16_t getVehicleSpeed();
    x  uint16_t getFuelPressure();

*/



