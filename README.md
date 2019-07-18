# Repository for REVERE Platform – SNOWFOX
This repository contains information regarding the –

-	Specifications of the physical platform
-	OS configuration for the system (opendlv.os)
-	Network Architecture
- Software stack for deployment 

***Specifications of the physical platform:***
- Platform Inaugurated: 1 September 2015
	- Vehicle: Volvo XC90 (2015)
	- Height: 1776 mm
	- Length: 4905 mm
	- Width (incl. review mirror): 2140 mm
	- Wheelbase: 2984 mm
	- Weight (dependent on motor type etc.): 2900 kg
	- Engine: In-line 4 cylinder Supercharged & Turbocharged engine (306 hp)

- Research-Specific Equipment/System Architecture
	- Vehicle CAN Gateway for Control & Vehicle Data
	- LIDAR: Velodyne HDL32 x 1
	- GPS-IMU: Applanix POS LV-220 x 1
	- Cameras:
		- Axis M1124-E (1280 x 720) x 1
		- Basler ACA2040-35GC (2048 x 1536) x 2
		- Stereo Camera from Veoneer
	- Radars (non-production): Veoneer (in process)
	- Computing HW for data processing and logging
	- Timesync HW: Meinberg M500 (PTP)
	- Dedicated on-board power supply: Mastervolt

***OS configuration for the system (opendlv.os):***

Refer to [computer/revere-snowfox-x86_64-1](https://github.com/chalmers-revere/opendlv-platform-snowfox/tree/master/computer/revere-snowfox-x86_64-1) on this repo and https://github.com/chalmers-revere/opendlv.os for further information.

***Network Architecture:***

Refer to [SnowfoxNetworkArchitecture_20190716.pdf](https://github.com/chalmers-revere/opendlv-platform-snowfox/blob/master/SnowfoxNetworkArchitecture_20190716.pdf)

***Software stack for deployment:***

The platform runs open source software developed in-house called OpenDLV which uses two specific concepts:

- Micro-services
- Containerized Deployment: Docker

For further info about OpenDLV, refer to https://github.com/chalmers-revere/opendlv

Depending on the sensor cluster activated on the platform, YAML files are used for deploying microservices linked to sensor interfaces, data logging, video encoding, visualization, etc.

All information regarding the individual microservices can be found on https://github.com/chalmers-revere/opendlv.
