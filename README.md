# elasticsearch-crystal
Converting the Ruby Elasticsearch Library to Crystal

You need to clone elasticsearch repo, this contains the integration tests yaml.

run tests by doing:

`docker run -d -p 9250:9200 elasticsearch:5.2`

`crystal spec test/integation/cat/*_spec.cr`


