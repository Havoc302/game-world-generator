
$shipList = Get-ChildItem 'G:\Colonial_Alliance_Game\WIP\Deck Maps\Ships' | Select-Object -ExpandProperty FullName

foreach ($file in (Get-Random -InputObject $shipList -Count 1)) {
    Start-Process $file
}

$list = $list -split "`n"

$returnedEvent = Get-Random -InputObject $list

$shipStatList = @{}

$shipData = @{}
$shipData.Name = "90t Armed Shuttle"
$shipData.Class = "Large Armed Shuttle"
$shipData.Description = "This large armed shuttle is a very old model in the Alliance now but it remains one of the most popular designs in the outer colonies, a steadfast transport capable of moving 34 passengers and 4 crew comfortably from place to place. With it's focus on protection and comfort the shuttle is not the fastest in Alliance space but it will get you where you want to go safely. The standard model comes with two high powered lasers in a fixed forward position, 2 warp disruption missiles, 2 EMP missiles, a sandcaster countermeasure system, and two particle beam turrets."
$shipData.ModelBuildYear = "2840"
$shipData.Mass = "90t"
$shipData.CargoLimit = "9t"
$shipData.AccelerationSpace = "80m/s2"
$shipData.MaxSpeed100kPa = "1000m/s"
$shipData.MaxSpeedspace = "300,000m/s"
$shipData.MaxG = "8G"
$shipData.MaxWarpspeed = "370c"
$shipData.WarpDriveChargeTime = "30s"
$shipData.TurnRate = "0.8r/s"
$shipData.MaxGLanding = "1.8"
$shipData.PrimaryPowerPlant = ""
$shipData.SecondaryPowerPlant = ""
$shipData.SensorSuite = ""
$shipData.TargetingComputer = ""
$shipData.CommunicationSystem = ""
$shipData.FlightController = ""
$shipData.Recycler = "No"
$shipData.Replicator = "No"
$shipData.CrewQuarters = "0"
$shipData.CrewStations = "4"
$shipData.PassengerQuarters = "0"
$shipData.PassengerSeating = "34"
$shipData.WarpDriveFuelStorage = "50Ly"
$shipData.SublightFuelStorage = "One Month"
$shipData.FixedWeaponHardpoints = "2"
$shipData.MissileHardpoints = "4"
$shipData.TorpedoLaunchers = "0"
$shipData.TurretWeaponHardpoints = "2"
$shipData.CountermeasureHardpoints = "1"
$shipData.ExternalUtilityHardpoints = "2"
$shipData.InternalUtilityHardpoints = "8"
$shipData.AtmosphericShields = "10"
$shipData.MainShieldModel = ""
$shipData.MainShieldHP = "500"
$shipData.BussardCollector = "Yes"