import vibe.vibe;

void main()
{
	auto settings = new HTTPServerSettings;
	settings.port = 8081;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	auto listener = listenHTTP(settings, &hello);
	scope (exit)
	{
		listener.stopListening();
	}

	logInfo("Please open http://127.0.0.1:8081/ in your browser.");
	runApplication();
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeBody("Hello, World!");
}
