[![Build Status](https://travis-ci.org/FHG-IMW/epo-ops.svg?branch=master)](https://travis-ci.org/FHG-IMW/epo-ops)
[![Code Climate](https://codeclimate.com/github/FHG-IMW/epo-ops/badges/gpa.svg)](https://codeclimate.com/github/FHG-IMW/epo-ops)

# epo-ops
Ruby interface to the EPO Open Patent Services (OPS).

[Full documentation can be found here](http://www.rubydoc.info/gems/epo-ops/)



# Usage

## Quickstart
Simply install this gem and start a ruby console.
```
$ gem install epo-ops
$ irb
```

and start querying the API

```ruby
require 'epo/ops'

patent_application = EpoOps::PatentApplication.find("EP14795538")
patent_application.classifications # ["A47B21/04", "A47B23/04", "A47B19/00"]
```

## Advanced Usage

### OAuth

EPO offers an anonymous developer access to their API with very little quota. To get extended quotas you can register
an account at the [EPO for OAuth](https://developers.epo.org/user/register)

After your account has been approved configure your credentials

```ruby

Epo::Ops.configure do |conf|
  conf.authorization = :oauth
  conf.consumer_key = "YOUR_KEY"
  conf.consumer_secret = "YOUR_SECRET"
end

```

The temporary access token is kept in memory for subsequent retrievals. To share this between several processes the
token storage strategy may be changed as shown in `epo/ops/token_store` for redis.


### Querying and searching patent applications

Currently this gem focuses mostly around patent applications.
It is possible to search for specific applications by application number and to search for applications using a
CQL search query

For example to find all applications in IPC Class _A01_ (and all subclasses) that were changed between 2016-01-01 and 2016-01-02

```ruby
query = EpoOps::SearchQueryBuilder.build("A01",Date.parse("2016-01-01"), Date.parse("2016-01-02"))
applications = EpoOps::PatentApplication.search(query)
puts application.count # 1234
applications.map {|application| puts application.application_nr } # print all application numbers
applications.map {|application| application.fetch} # fetch complete bibliographic data for each document

```

The Request will return a search result containing the number of all applications matching the search. By default the
search will return 25 documents (max is 100). You can use `start_rang` and `end_range` of `EpoOps::SearchQueryBuilder.build`
to page through all results

**Note: EPO will always only return up to 2000 documents even if the search would return more**


### Search for all Patents on a given Date

To circumvent the restriction of max 2000 search results this gem
offers a convenient method to search for all patents updated on a given date and/or a given IPC class

```ruby
EpoOps::Register.search("A", Date.new(2016,2 ,3))
# or for all ipc classes
EpoOps::Register.search(nil, Date.new(2016,2 ,3))
```

You can now retrieve the bibliographic entries of all these:

```ruby
references = EpoOps::Register.search(nil, Date.new(2016,2 ,3))
references.map { |ref| EpoOps::Register.biblio(ref) }
```

**Note: Both operations take a considerable amount of time. Also you may not
want to develop and test with many of these requests, as they can quite quickly**


# Further Reading

The EPO provides [a developer playground](https://developers.epo.org/), where you can test-drive the OPS-API.
They also provide extensive [documentation](https://www.epo.org/searching-for-patents/technical/espacenet/ops.html)
of the different endpoints and how to use them (see the 'Downloads' section).


# Development

This gem is still an early version and it is far from covering the whole API.
If you are interested to include different API endpoints than the register it should be easy to include those and we
are happy to accept pull requests.