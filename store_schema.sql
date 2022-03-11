
PRAGMA foreign_keys = off;

.mode column

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    email           VARCHAR(100)    NOT NULL,
    name            VARCHAR(100)    NOT NULL,
    password        VARCHAR(50)     NOT NULL,
    balance         DECIMAL(8,2)    NOT NULL,
    PRIMARY KEY (email)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    customer_email  VARCHAR(100),
    date            VARCHAR(100)    NOT NULL,
    totalcost           INT(10)         NOT NULL,
    FOREIGN KEY (customer_email) references users(email)
    -- PRIMARY KEY (customer_email, date)
);

DROP TABLE IF EXISTS category;
CREATE TABLE category(
    name            VARCHAR(50)     NOT NULL,
    PRIMARY KEY (name)
);

DROP TABLE IF EXISTS product;
CREATE TABLE product(
    ticket          VARCHAR(5)     NOT NULL,
    name            VARCHAR(20)    NOT NULL,
    price           DECIMAL(6,2),
    stock           INT(10)        NOT NULL,
    category        VARCHAR(50)     NOT NULL,
    descryption     VARCHAR(1000),
    PRIMARY KEY (ticket),
    FOREIGN KEY (category) references category(name)
);

DROP TABLE IF EXISTS holdings;
CREATE TABLE holdings (
    customer_email  VARCHAR(100)    NOT NULL,
    ticket          VARCHAR(5)      NOT NULL,
    quantity        INT(50)         NOT NULL,
    -- balance         DECIMAL(8,2)    NOT NULL,
    PRIMARY KEY (customer_email, ticket),
    FOREIGN KEY (customer_email) references users(email),
    FOREIGN KEY (ticket) references product(ticket)
);

DROP TABLE IF EXISTS orderitem;
CREATE TABLE orderitem(
    customer_email  VARCHAR(100),
    date            VARCHAR(100),
    ticket_id       VARCHAR(5),
    quantity        INT(10),
    FOREIGN KEY (customer_email) references orders(customer_email),
    FOREIGN KEY (date) references orders(date),
    FOREIGN KEY (ticket_id) references product(ticket)
    -- PRIMARY KEY (customer_email, date, ticket_id)
);

PRAGMA foreign_keys = on;

-- users (email, name, password, balance)
INSERT INTO users VALUES ('phan@gwu.edu', 'phan', 'pass', 100000.00);
INSERT INTO users VALUES ('test@gwu.edu', 'testuser', 'testpass', 100000.00);
INSERT INTO users VALUES ('user1@gwu.edu', 'user1', 'pass', 100000.00);
INSERT INTO users VALUES ('user2@gwu.edu', 'user2', 'pass', 100000.00);
INSERT INTO users VALUES ('user3@gwu.edu', 'user3', 'pass', 100000.00);
INSERT INTO users VALUES ('user4@gwu.edu', 'use4', 'pass', 100000.00);

-- category (name)
INSERT INTO category VALUES ('technology');
INSERT INTO category VALUES ('communication');
INSERT INTO category VALUES ('semiconductor');
INSERT INTO category VALUES ('industry');
INSERT INTO category VALUES ('cryptocurreny');
INSERT INTO category VALUES ('entertainment');
INSERT INTO category VALUES ('airline');

-- product (ticket, name, price, stock, category)
INSERT INTO product VALUES ('AAPL', 'Apple', 159.30, 1000, 'technology',"Apple Inc. designs, manufactures and markets smartphones, personal computers, tablets, wearables and accessories, and sells a variety of related services. The Company's products include iPhone, Mac, iPad, and Wearables, Home and Accessories. iPhone is the Company's line of smartphones based on its iOS operating system. Mac is the Company's line of personal computers based on its macOS operating system. iPad is the Company's line of multi-purpose tablets based on its iPadOS operating system. Wearables, Home and Accessories includes AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch and other Apple-branded and third-party accessories. AirPods are the Company's wireless headphones that interact with Siri. Apple Watch is the Company's line of smart watches. Its services include Advertising, AppleCare, Cloud Services, Digital Content and Payment Services. Its customers are primarily in the consumer, small and mid-sized business, education, enterprise and government markets.");
INSERT INTO product VALUES ('MSFT', 'Microsoft', 278.91, 1000, 'technology',"Microsoft Corporation is a technology company. The Company develops and supports a range of software products, services, devices, and solutions. The Company's segments include Productivity and Business Processes, Intelligent Cloud, and More Personal Computing. The Company's products include operating systems; cross-device productivity applications; server applications; business solution applications; desktop and server management tools; software development tools; and video games. It also designs, manufactures, and sells devices, including personal computers (PCs), tablets, gaming and entertainment consoles, other intelligent devices, and related accessories. It offers an array of services, including cloud-based solutions that provide customers with software, services, platforms, and content, and it provides solution support and consulting services. It markets and distributes its products and services through original equipment manufacturers, direct, and distributors and resellers.");
INSERT INTO product VALUES ('AMZN', 'Amazon', 2936.35, 1000, 'technology',"Amazon.com, Inc. offers a range of products and services through its Websites. The Company's products include merchandise and content that it purchases for resale from vendors and those offered by third-party sellers. It also manufactures and sells electronic devices, including Kindle, Fire tablet, Fire TV, Echo, Ring, and other devices and it develops and produce media content. It operates through three segments: North America, International and Amazon Web Services (AWS). AWS offers a set of technology services, including compute, storage, database, analytics, machine learning, Internet of Things, cloud and serverless computing. In addition, it provides services, such as advertising to sellers, vendors, publishers, authors, and others, through programs such as sponsored ads, display, and video advertising. It also offers Amazon Prime, a membership program that includes free shipping, access to streaming of various movies and television (TV) episodes, including Amazon Original content.");
INSERT INTO product VALUES ('GOOG', 'Alphabet', 2529.29, 1000, 'communication',"Alphabet Inc. is a holding company. The Company's segments include Google Services, Google Cloud and Other Bets. Google Services includes products and services such as ads, Android, Chrome, hardware, Google Maps, Google Play, Search, and YouTube. Google Cloud includes Google's infrastructure and data analytics platforms, collaboration tools, and other services for enterprise customers. Its Google Cloud provides enterprise-ready cloud services, including Google Cloud Platform and Google Workspace. Its Google Cloud Platform enables developers to build, test, and deploy applications on its infrastructure. Its Google Workspace collaboration tools include applications like Gmail, Docs, Drive, Calendar and Meet. Its hardware products include Pixel phones, Chromecast with Google TV and the Google Nest Hub smart display. The Other Bets segment is engaged in the sales of Internet and television services, licensing and research and development (R&D) services.");
INSERT INTO product VALUES ('FB', 'Meta Platfrom', 187.47, 1000, 'communication',"Meta Platforms Inc., formerly Facebook, Inc., is focused on building products that enable people to connect and share through mobile devices, personal computers virtual reality headsets, and in-home devices. Its segments include Family of Apps (FoA) and Facebook Reality Labs (FRL). FoA segment includes Facebook, Instagram, Messenger, WhatsApp and other services. FRL segment includes augmented and virtual reality related consumer hardware, software and content. Facebook enables people to connect, share and communicate with each other on mobile devices and personal computers. Instagram helps people to express themselves through photos, videos, and private messaging, and connect with and shop from businesses and creators. Messenger is a messaging application for people to connect with friends, family, groups, and businesses across platforms and devices. WhatsApp is a messaging application that is used by people around the world to communicate and transact.");
INSERT INTO product VALUES ('NVDA', 'Nvidia', 213.52, 1000, 'semiconductor',"Nvidia Corporation is an artificial intelligence computing company. It operates through two segments: Graphics and Compute & Networking. Its Graphics segment includes GeForce graphics processing unit (GPU), the GeForce NOW game streaming service and related infrastructure, and solutions for gaming platforms; Quadro/NVIDIA RTX GPUs for enterprise workstation graphics; virtual graphics processing unit (vGPU) software for cloud-based visual and virtual computing; and automotive platforms for infotainment systems. Its Compute & Networking segment includes Data Center platforms and systems for artificial intelligence (AI), high-performance computing (HPC), and accelerated computing; Mellanox networking and interconnect solutions; automotive AI Cockpit, autonomous driving development agreements, and autonomous vehicle solutions; and Jetson for robotics and other embedded platforms. Its platforms address markets such as Gaming, Professional Visualization, Data Center, and Automotive.");
INSERT INTO product VALUES ('TSLA', 'Tesla', 804.58, 1000, 'industry', "Tesla, Inc. designs, develops, manufactures, sells and leases electric vehicles and energy generation and storage systems, and offers services related to its sustainable energy products. The Company's segments include automotive, and energy generation and storage. The automotive segment includes the design, development, manufacturing, sales and leasing of electric vehicles as well as sales of automotive regulatory credits. The energy generation and storage segment include the design, manufacture, installation, sales and leasing of solar energy systems and energy storage products, services related to its products, and sales of solar energy system incentives. Its automotive products include Model 3, Model Y, Model S and Model X. Model 3 is a four-door sedan. Model Y is a sport utility vehicle (SUV) built on the Model 3 platform. Model S is a four-door sedan. Model X is an SUV. The Company's energy storage products include Powerwall, Powerpack and Megapack.");
INSERT INTO product VALUES ('BA', 'Boeing', 169.17, 1000, 'industry', "The Boeing Company is an aerospace firm. The Company operates in four segments: Commercial Airplanes (BCA); Defense, Space & Security (BDS); Global Services (BGS), and Boeing Capital (BCC). BCA segment develops, produces and markets commercial jet aircraft and provides fleet support services, principally to the commercial airline industry. BDS segment is engaged in the research, development, production and modification of manned and unmanned military aircraft and weapons systems for strike, surveillance and mobility. BGS segment provides services to commercial and defense customers. BCC's segment portfolio consists of equipment under operating leases, finance leases, notes and other receivables and assets held for sale.");
INSERT INTO product VALUES ('BTC', 'Bitcoin', 38919.10, 1000, 'cryptocurreny', "Bitcoin is a decentralized digital currency, without a central bank or single administrator, that can be sent from user to user on the peer-to-peer bitcoin network without the need for intermediaries.");
INSERT INTO product VALUES ('AMD', 'Advanced Micro Devices', 106.46, 1000, 'semiconductor',"Advanced Micro Devices, Inc. is a global semiconductor company. The Company's products include x86 microprocessors (CPUs), accelerated processing units (APUs), discrete graphics processing units (GPUs), semi-custom System-on-Chip (SOC) products and chipsets for the personal computer (PC), gaming, datacenter and markets. The Company's segments include the Computing and Graphics segment, and the Enterprise, Embedded and Semi-Custom segment. The Computing and Graphics segment primarily includes desktop and notebook processors and chipsets, discrete and integrated graphics processing units (GPUs), data center and professional GPUs and development services. The Enterprise, Embedded and Semi-Custom segment primarily includes server and embedded processors, semi-custom SoC products, development services and technology for game consoles.");
INSERT INTO product VALUES ('SNAP', 'Snapchat', 31.74, 1000, 'communication',"Snap Inc. is a camera company. The Company's flagship product, Snapchat, is a camera application that helps people to communicate through short videos and images known as a Snap. Snapchat contains of five tabs: Camera, Communication, Snap Map, Stories and Spotlight. Camera is the starting point for creation in Snapchat. Snapchat opens directly to the Camera, helping to create a Snap and send it to friends. Communication allows users to send messages through text, Snaps, and voice or video calling to friends collectively or individually. Snap Map is a live and personalized map that allows Snapchatters to connect with friends and explore what is going on in their local area. Stories feature content from a Snapchatters friends, the Company's community, and content partners. Spotlight is a way to share user-generated content with the entire Snapchat community. The Company's advertising products include Snap Ads and augmented reality (AR) Ads.");
INSERT INTO product VALUES ('ETH', 'Ethereum', 2608.08, 1000, 'cryptocurreny',"Ethereum is a decentralized, open-source blockchain with smart contract functionality. Ether is the native cryptocurrency of the platform. Among cryptocurrencies, Ether is second only to Bitcoin in market capitalization. Ethereum was conceived in 2013 by programmer Vitalik Buterin.");
INSERT INTO product VALUES ('DAL', 'Delta', 32.55, 1000, 'airline',"Delta Air Lines, Inc. provides scheduled air transportation for passengers and cargo throughout the United States and across the world. The Company's segments include Airline and Refinery. The Company has hubs and market presence in Amsterdam, London-Heathrow, Mexico City, Paris-Charles de Gaulle and Seoul-Incheon. Its airline segment is managed as a single business unit that provides scheduled air transportation for passengers and cargo throughout the United States and around the world and includes its loyalty program, as well as other ancillary airline services. Its refinery segment operates for the benefit of the airline segment by providing jet fuel to the airline segment from its own production and through jet fuel obtained through agreements with third parties. The refinery's production consists of jet fuel, as well as non-jet fuel products. It also maintains complementary portfolio businesses, such as its cargo business and its Maintenance, Repair and Overhaul (MRO) operation.");
INSERT INTO product VALUES ('AMC', 'American Multi-Cinema', 15.32, 1000, 'entertainment',"AMC Entertainment Holdings, Inc. is a theatrical exhibition company. The Company conducts operations through two segments: U.S. markets and International markets. It licenses first-run films from distributors owned by film production companies and from independent distributors on a film-by-film and theatre-by-theatre basis. It also offers food and beverage products, including drinks and meals, popcorn, soft drinks, candy and hot dogs, coffee, snacks, beers, wine and mixed drinks, and other gourmet products. In U.S. markets, it operates theatres in approximately 44 states and the District of Columbia. In International markets, it operates theatres in approximately 13 European countries and in Saudi Arabia. It operates approximately 1,004 theatres and over 11,041 screens in approximately 15 countries, including over 636 theatres with a total of approximately 8,094 screens in the United States and over 368 theatres and approximately 2,947 screens in European markets and Saudi Arabia.");
INSERT INTO product VALUES ('GME', 'Gamestop', 100.56, 1000, 'entertainment',"GameStop Corp. is focused on offering games, entertainment products and technology through its e-commerce properties and stores. The Company offers a range of selection of pre-owned video gaming consoles, accessories, monitors, television (TV) and other consumer electronics and video game titles, in both physical and digital formats. The Company also offers a variety of POP vinyl figures, collectibles, and board games. The Company, through its buy-sell-trade program, gamers can trade in video game consoles, games, and accessories, as well as consumer electronics for cash or in-store credit. The Company's geographic segments include United States, Canada, Australia and Europe. The Company's consumer network also includes www.gamestop.com and Game Informer magazine.");
