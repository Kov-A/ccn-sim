
#include <iostream>
#include <iostream>

 #include "kovi-p2p.h"
 #include "ns3/packet.h"
 #include "ns3/simulator.h"
 #include "ns3/log.h"
 #include "ns3/mpi-interface.h"

 NS_LOG_COMPONENT_DEFINE ("KoviPointToPointNetDevice");

 namespace ns3 {

 NS_OBJECT_ENSURE_REGISTERED (KoviPointToPointNetDevice);

 TypeId
 KoviPointToPointNetDevice::GetTypeId (void)
 {
  static TypeId tid = TypeId ("ns3::KoviPointToPointNetDevice")
		  .SetParent<PointToPointNetDevice> ()
		  .AddConstructor<KoviPointToPointNetDevice> ();
  return tid;
 }
 void
 KoviPointToPointNetDevice::LinkupDown ( bool state)
 {
	 m_linkUp = state;
 }
 }


