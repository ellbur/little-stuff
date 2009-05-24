
#include <libgmailclientcxx/allheaders.hpp>
#include <string>
#include <iostream>

using namespace libgmailclientcxx;
using namespace std;

void eventListener(void*, const Event&);

int main()
{
	GMailClient *client;
	ClientData *clientData;
	
	client = new GMailClient();
	clientData = client->getClientData();
	clientData->addListener(eventListener, NULL);
	
	client->login("joe1234567", "93sdjf389");
	
	// hangs. Will return when client logs out
	client->block();
	
	return 0;
}

void eventListener(void *data, const Event &event) {
	if (event.type == Event::OWN_CHAT_RECEIVED) {
		cout << "I said " << event.chatLine->text << endl;
	}
}
