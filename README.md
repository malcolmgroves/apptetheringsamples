# App Tethering Samples

Source for the sample apps from my App Tethering Deep-dive session. Samples are:

DiscoverManagers
----------------
This sample tries to highlight the difference between calling AutoConnect and DiscoverManagers. It does this by using DiscoverManagers to implement the same logic that AutoConnect performs. 

Events
------
This sample shows discovering, pairing, sharing tersistent and transient Resources (both Data and Stream Resources) and triggering persistent and transient Actions. 

Swarm
-----
This demo highlights the use of OnNewManager to flip discovery on it's head. Rather than asking if there are any apptethering enabled apps out there, this allows you to be told when new ones start. Start multiple copies of the Drone app. As they start, all the running Drones are notified of the new memeber and pair, maintaining a list of all other members of the swarm. As Drones close down, all the running apps are notified and update their list. 

