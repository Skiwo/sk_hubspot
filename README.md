# Skiwo Hubspot

## Note
The Skiwo::Hubspot gem is to be considered to be in alpha stage and
the public interface might change.

## Installation

Install the gem and add to the application's Gemfile by executing:

    gem "sk_hubspot", git: "git@github.com:Skiwo/sk_hubspot.git"

    $ bundle install

## Usage

The Skiwo Hubspot gem is a wrapper for the `hubspot-api-client gem`.
It provides convenient methods to Hubspot's crm api.

### Configuration
The `Skiwo::Hubspot::Client` will look for `ENV['HUBSPOT_TOKEN']` to get the `access_token`.
It can also be configured like this:

```ruby
Skiwo::Hubspot.configure do |config|
  config.access_token = 'some-access-token'
  config.default_deal_owner_id = 'some-user-id-on-hubspot'
  config.default_pipeline_id = 'some-pipeline-id-on-hubspot'
end
```

### The CRM Object
A successful request to the [Hubspot CRM API](https://developers.hubspot.com/docs/api/crm/understanding-the-crm) will  result in one or more objects of type `Skiwo::Hubspot::CrmObject`.

The Skiwo Hubspot gem provides classes like `Contact`,`Company` and `Deal` that corresponds to Hubspot CRM Objects.
CRM objects have instance methods for mutating the record on Hubspot.
When working with instances, any errors can be accessed by calling `crm_object.errors`

### Properties
Hubspot CRM objects have properties like `firstname`, `lastname`, and `email`.
The object properties uses non-separated and underscore separated labels.
Example: `lastmodifieddate` and `hs_object_id`

The Hubspot CRM supports custom properties that clients can create on the website or via the api.

### Skiwo's Custom Properties

#### Platform ID
A reference from the Skiwo platform record and to the crm object on
Hubspot is set via the custom property named `platform_id` on Hubspot.

Example:

- Manymore: User.id => Hubspot::Contact.platform_id
- Salita: Person.id => Hubspot::Contact.platform_id
- Salita: Order.id => Hubspot::Deal.platform_id

Example: `Skiwo::Hubspot::Contact.find_by_platform_id(id)` to find the record on Hubspot.

### Find Objects on Hubspot

You can pass a block to the methods that calls the hubspot api to handle any errors.
If you don't provide a block, the method returns a tuple with `[result_object, error]`

**Example: Find one contact by the hubspot object id**

```ruby
# With block returns a Skiwo::Hubspot::CrmObject
# => Skiwo::Hubspot::Contact
contact = Skiwo::Hubspot::Contact.find(hubspot_id) { |error| fail error }
puts contact.email

# Without block returns a tuple
# => [Skiwo::Hubspot::Contact, Skiwo::Hubspot::ApiError]
contact, error = Skiwo::Hubspot::Contact.find(hubspot_id)

if error
  fail error
end
puts contact.email
```

### Create objects on Hubspot

**Example: create a new contact on Hubspot**

```ruby
# Note: you can't create two records of the same type
# on Hubspot with the same platform id
contact = Skiwo::Hubspot::Contact.find_by_platform_id(platform_id) { |error| fail error }

unless contact
  attributes = { firstname: "Don", lastname: "Johnson", email: "don@example.com" }
  contact = Skiwo::Hubspot::Contact.create(properties: attributes) { |error| fail error }
end
```

### Update an object on Hubspot

```ruby
contact = Skiwo::Hubspot::Contact.find_by_platform_id(platform_id) { |error| fail error }

if contact.update(firstname: "Donnie Wayne")
  handle_success
else
  puts contact.errors
end
```

### Associations
Hubspot has the concept of associations between crm objects.
A contact can be associated to one or more companies and a company
to one or more contacts.

```ruby
company = Skiwo::Hubspot::Company.find(company_id)
contact = Skiwo::Hubspot::Contact.find(contact_id)
association = Skiwo::Hubspot::Association.new(from: contact, to: company)

if association.save
  ...
else
  puts association.errors
end

# or
if contact.add_company(company)
  ...
else
  puts contact.errors
end

```
You can pass a list of associations when creating a Hubspot CRM object.

```ruby
associations = []
properties = { ... }
company =  Skiwo::Hubspot::Company.find(id)
deal =  Skiwo::Hubspot::Deal.find(id)

associations << Skiwo::Hubspot::Association.new(to: company, type: "contact_to_company")
associations << Skiwo::Hubspot::Association.new(to: deal, type: "contact_to_deal")

contact = Skiwo::Hubspot::Contact.create(
  properties: properties,
  associations: associations
) do { |err| fail err }
```


**Create Contact with associated Company in one request**

It is possible to use the property `associatedcompanyid` to associate one company with a contact when the contact is first created.
If the company is set on creation it will be labeled as the primary company automatically by Hubspot.

```ruby
company = Skiwo::Hubspot::Company.find_by_platform_id(platform_id) { |error| fail error }
attributes = {
  firstname: "Don",
  lastname: "Johnson",
  email: "don@example.com",
  associatedcompanyid: company.id
}

contact = Skiwo::Hubspot::Contact.create(properties: attributes) { |error| fail error }
```
## Roadmap

* Consider to add a mapping of attributes from the platform objects
* Add more custom properties

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

