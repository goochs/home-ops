// @ts-check
/// <reference path="types-dnscontrol.d.ts" />

// Providers:
var REG_PORKBUN = NewRegistrar("porkbun");
var DNS_PORKBUN = NewDnsProvider("porkbun");

// Domains:
DEFAULTS(
  DnsProvider(DNS_PORKBUN),
  DefaultTTL("5m"),
END);

D("serek.xyz", REG_PORKBUN,
    A("@", "1.2.3.4")
);
