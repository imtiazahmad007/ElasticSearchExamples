# Elastic Search Query DSL



# An index search would be:                   /myidx/_search
# Or if you want to search the type as well:  /myidx/mytype/_search

# Create our index:
PUT /planet/
{
"mappings": {
"hacker": {
"properties": {
  "handle": {"type": "string"},
  "hobbies": {"type": "string", "analyzer": "snowball"}}}}}

# Seed data to index:
PUT /planet/hacker/1
{"handle": "mark",
"hobbies": ["rollerblading", "hacking", "coding"]}
PUT /planet/hacker/2
{"handle": "gondry",
"hobbies": ["writing", "skateboarding"]}
PUT /planet/hacker/3
{"handle": "jean-michel",
"hobbies": ["coding", "rollerblades"]}


# Lucene's general strategy for querying is to first exclude all documents with no matches for
# search terms, then rank the documents that do match.
A document’s score will be higher when:
### The matched term is ’rare’, which is to say that it is found in fewer documents than other terms 
### The term appears in the document at a greater frequency than other terms within the document 
### If multiple terms are in the query and the document contains more of the query’s terms than other documents 
### The field or document had a boost factor specified at index-time or query time 

-----------------------------------------------------------------------------------------------
The Basics of Querying
-----------------------------------------------------------------------------------------------

# Simple Query:
# Here is the query example looking for matches for the term “skateboard” in the “hobbies” field:

POST /planet/_search
{
  "size": 12,
  "query": {"match": {"hobbies": "skateboard"}}
}

# The result:
{
"took": 2, "timed_out": false,
"_shards": {"total": 5, "successful": 5, "failed": 0},
"hits": {
"total": 1, "max_score": 0.15342641,
"hits": [
{
"_index": "planet", "_type": "hacker",
"_id": "2", "_score": 0.15342641,
"_source": {
"handle": "gondry",
"hobbies": ["writing reddit comments", "skateboarding"]}}]}}

# The match query by default executes an or of tokens. So if in addition to skateboard, there was
# another value, it would do an or.

# Using a Match Query to Search for a Phrase

POST /planet/_search
{"query": {"match": {"hobbies": {"query": "writing reddit comments", "type": "phrase"}}}}

### Matches gondry who does indeed like to write reddit comments

POST /planet/_search
{"query": {"fuzzy": {"hobbies": "skateboarig"}}}

# Matches gondry who has "skateboarding" listed as a hobby. Uses fuzzy query type based on string edit distance
# At the time of writing, 36 different Query types, and 25 different Filter types comprising the Query DSL.


-------------------------------------------------------------------------------------------------
Document Analysis
-------------------------------------------------------------------------------------------------
# When a search is performed on an analyzed field, the query itself is analyzed, matching it up to documents
# which are analyzed when added to the database. Reducing words to stems like what the snowball analyzer does
# normalizes the text allowing fo rfast efficent lookups. Whether you're searching for rollerblading in any form, 
# internally we're jsut looking for "rollerblad".

The process by which documents are analyzed is as follows:
1). # A document update or create is received via a PUT or POST
2). # The field values in the document are each run through an analyzer which converts each value to 
    # zero, one or more indexable tokens.
3). # The tokenized values are stored in an index, pointing back to the full version of the document. 

# In this way an efficient inverted index is built up, allowing for exact matches to a query

-------------------------------------------------------------------------------------------------
Mixing Queries, Filters, and Facets
-------------------------------------------------------------------------------------------------

# The search API also supports filters, facets, sorting, routing to specific shards, and much more.

# An Complex Search’s Skeleton

POST /planet/_search
{
"from": 0,
"size": 15,
"query": {"match_all": {}},
"sort": {"handle": "desc"},
"filter": {"term": {"_all": "coding"}},
"facets": {
"hobbies": {
"terms": {
"field": "hobbies"}}}}

FACETS:
# Facets are always attached to a query, letting you return aggregate statistics alongside regular query results. 
# Facets are highly configurable and are somewhat composable. In addition to counting distinct field values, 
# facets can count by more complex groupings, such as spans of time, nest filters, and even include full, 
# nested, elasticsearch queries!

FILTERS:
# While queries describe which documents appear in results and how they are to be scored, filters only describe 
# which documents appear in results. This can result in a significantly faster query. Additionally, some criteria 
# can only be specified via a filter, no query equivalent exists. Filters can be used to optimize a query by 
# efficiently cutting down the result set without executing relatively expensive scoring calculations. Filters may 
# also be used in the case where a term must be matched against, but contribution to the document’s overall score 
# should be be a fixed amount regardless of the TF/IDF score. Additionally, unlike queries, filters may be 
# cached, leading to significant performance gains when repeatedly invoked.






