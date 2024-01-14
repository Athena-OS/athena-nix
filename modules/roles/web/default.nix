{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    aflplusplus
    archivebox
    apachetomcatscanner
    arjun
    boofuzz
    brakeman
    burpsuite
    cantoolz
    chipsec
    clairvoyance
    commix
    crackql
    crlfuzz
    dalfox
    dirb
    dirstalk
    dontgo403
    doona
    feroxbuster
    ffuf
    firewalk
    gau
    ghauri
    gobuster
    gospider
    gowitness
    graphinder
    graphqlmap
    graphw00f
    hakrawler
    honggfuzz
    httpx
    interactsh
    jaeles
    joomscan
    jsbeautifier
    jwt-hack
    katana
    kiterunner
    log4j-scan
    mdk4
    metasploit
    mitm6
    mitmproxy
    mitmproxy2swagger
    mongoaudit
    monsoon
    nikto
    nosqli
    nuclei
    photon
    plecost
    psudohash
    python311Packages.arsenic
    python311Packages.httpx
    python311Packages.pyjsparser
    python311Packages.scrapy
    python311Packages.scrapy-deltafetch
    python311Packages.scrapy-fake-useragent
    python311Packages.scrapy-splash
    python311Packages.thefuzz
    radamsa
    responder
    ruler
    snallygaster
    soapui
    sqlmap
    subjs
    #swftools
    trinity
    wafw00f
    wapiti
    webanalyze
    websploit
    wfuzz
    whatweb
    wpscan
    wuzz
    xsser
    yersinia
    zap
    zzuf
  ];
}
