#ifndef NS3_KOVI_P2P_H_
#define NS3_KOVI_P2P_H_

#include <set>
#include <ns3-dev/ns3/ptr.h>
#include <ns3-dev/ns3/log.h>
#include <ns3-dev/ns3/simulator.h>
#include <ns3-dev/ns3/packet.h>
#include <ns3-dev/ns3/callback.h>
#include <ns3-dev/ns3/string.h>
#include <ns3-dev/ns3/boolean.h>
#include <ns3-dev/ns3/uinteger.h>
#include <ns3-dev/ns3/integer.h>
#include <ns3-dev/ns3/double.h>
#include <ns3-dev/ns3/type-id.h>
#include <ns3-dev/ns3/ndnSIM/model/ndn-name.h>
#include <ns3-dev/ns3/ndnSIM/apps/ndn-consumer-cbr.h>

namespace ns3 {
class KoviPointToPointNetDevice: public PointToPointNetDevice {
public:
	static TypeId GetTypeId ();

	void LinkupDown (bool state);
	bool m_linkUp;
	KoviPointToPointNetDevice();

};

} /* namespace ns3 */
#endif /* NS3_KOVI_P2P_H */




