require("dotenv").config();
const fs = require("fs");
const { Client } = require("pg");

const dbConfig = {
  user: process.env.PG_USER,
  password: process.env.PG_PASS,
  host: process.env.PG_HOST,
  database: process.env.PG_DATABASE,
  port: process.env.PG_PORT,
};

let client;

async function executeSQLFile(filePath, dbClient) {
  try {
    const sql = fs.readFileSync(filePath, "utf-8");
    const queries = sql
      .split(";")
      .map((query) => query.trim())
      .filter((query) => query.length > 0);

    console.log(" Running Queries from", filePath);

    let logStream = fs.createWriteStream("query_results.log", { flags: "w" });

    for (const query of queries) {
      console.log("\n Executing Query:\n", query);
      logStream.write(`\n Executing Query:\n${query}\n\n`);

      try {
        const result = await dbClient.query(query);

        if (result.rows.length > 0) {
          let formattedResult = result.rows.map(row => JSON.stringify(row, null, 2)).join("\n");

          logStream.write(`✅ Query Results:\n${formattedResult}\n\n`); 
        } else {
          logStream.write("⚠️ No results found for this query.\n\n");
        }
      } catch (err) {
        console.error("❌ Query Execution Error:", err.message);
        logStream.write(`❌ Query Execution Error: ${err.message}\n\n`);
      }
    }

    logStream.end();
    console.log("✅ Results saved to query_results.log");
  } catch (error) {
    console.error("Error executing queries:", error.message);
  }
}

describe("Fleet Validation Tests", () => {
  beforeAll(async () => {
    client = new Client(dbConfig);
    await client.connect();
    console.log("✅ Connected to PostgreSQL");
  });

  afterAll(async () => {
    await client.end();
    console.log(" Disconnected from PostgreSQL");
  });

  test("Validate fleet data using SQL file", async () => {
    await expect(executeSQLFile("db.sql", client)).resolves.not.toThrow();
  });
});