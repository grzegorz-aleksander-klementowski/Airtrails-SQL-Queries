# Airtrails-SQL-Queries
SQL tool for travel agency's flight search. Manages routes, airport codes, flight schedules, and ticketing. Features algorithms for route generation and promotions. Error-resilient: from table recovery to server overload checks.

**Functionality:**

    Adding New Routes: Handles the addition of new air routes between airports in different cities, with full safeguards against errors such as intra-city routes.

    Airport Codes: Supports original airport codes, considering IATA and ICAO codes.

    Operators and Promotions: Handles airline operators for adding promotions, taking into account their original headquarters.

    Route Creation: Capable of creating routes with specified flights, route IDs, dates, times, and handling basic flight costs. Supports original flight codes.

    Ticket Purchasing: Feature for purchasing tickets, including customer data and available promotions.

    Travel Table: Creating and managing a travel table, including an algorithm for automatic creation of journeys and connections.

    Dependency Diagram: A diagram showing the relationships between individual tables.

    Search Algorithms: Advanced airport and route search algorithms, including checking if a plane is not heading to the same city and airport.

    Promotional Codes: Algorithm for generating promotional codes for travel agencies.

    Error Handling: Advanced error handling, including GeoBlock errors (403) and basic errors like a missing table (in which case the script automatically creates the missing table, protecting the database system from failure).

    Ticket Purchase Algorithm: An advanced ticket purchasing system, taking into account customer data and available promotions.

    Handling Multiple Promotions: Ability to handle multiple promotions for various routes simultaneously.

    Safeguards: Handling errors related to server overload, especially when many people are trying to purchase tickets at the same time.

**Installation Instructions:**

In addition to the scripts provided in the repository, users should acquaint themselves with the system requirements and configuration of the environment in which the database will be deployed.

    Ensure you have the appropriate environment for running SQL scripts.
    Clone the repository or download the files.
    Execute the scripts in the proper sequence (as instructed in the code or in a separate file).
    Confirm that all tables and procedures are correctly created.
    Start using the database!
