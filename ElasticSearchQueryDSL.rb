# Elastic Search Query DSL

=begin

An index search would be:                   /myidx/_search
Or if you want to search the type as well:  /myidx/mytype/_search

=end

# Here is the query example:

POST /planet/_search
{
  "size": 12,
  "query": {"match": {"hobbies": "skateboard"}}
}
