### topN_naive.sql

SQL query with group by on MVD and a WHERE clause. WHERE filter returns all items of all rows that have an element that matches the WHERE clause.

### topN_explain.json

Druid generated native plan for `topN_naive.sql`

### topN_filtered.json

Does a filter like a HAVING clause for the topN query using a filtered dimension spec, but how can we get the filter list populated with a query result?
