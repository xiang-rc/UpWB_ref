######   
#Makefile of all black- and white-box implementations on Intel 
######
CXX=g++
libs=/usr/lib/x86_64-linux-gnu/libgivaro.a,/usr/lib/x86_64-linux-gnu/libgmp.a,/usr/lib/x86_64-linux-gnu/libgmpxx.a

all: SPNBOX16_SBOXGEN SPNBOX16_BBI SPNBOX16_WBI WEM16_SBOXGEN WEM16_WBI WARX16_SBOXGEN WARX16_BBI WARX16_WBI  Yoroi16_BBI

SPNBOX16_SBOXGEN:SPNBOX16_SBOXGEN.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o SPNBOX16_SBOXGEN SPNBOX16_SBOXGEN.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

SPNBOX16_BBI:SPNBOX16_BBI.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o SPNBOX16_BBI SPNBOX16_BBI.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

SPNBOX16_WBI:SPNBOX16_WBI.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o SPNBOX16_WBI SPNBOX16_WBI.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

WEM16_SBOXGEN:WEM16_SBOXGEN.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o WEM16_SBOXGEN WEM16_SBOXGEN.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

WEM16_WBI:WEM16_WBI.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o WEM16_WBI WEM16_WBI.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

WARX16_SBOXGEN:WARX16_SBOXGEN.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o WARX16_SBOXGEN WARX16_SBOXGEN.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

WARX16_BBI:WARX16_BBI.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o WARX16_BBI WARX16_BBI.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

WARX16_WBI:WARX16_WBI.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o WARX16_WBI WARX16_WBI.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

Yoroi16_BBI:Yoroi16_BBI.C
	$(CXX) -O2 -Wall -DNDEBUG -UGIVARO_DEBUG -UDEBUG -std=gnu++11 -std=gnu++11 -o Yoroi16_BBI Yoroi16_BBI.C -Wl,$(libs) -lgivaro -lgmp -lgmpxx -static

clean:
	\rm  SPNBOX16_BBI SPNBOX16_WBI WEM16_WBI WARX16_BBI WARX16_WBI Yoroi16_BBI
