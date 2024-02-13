# Skiwo Hubspot

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

The Skiwo Hubspot gem is a wrapper for the `hubspot-api-client gem`.
It provides convenient methods to Hubspot's crm api.

### Calling The Hubspot API
You can pass a block to methods that calls the hubspot api to handle any errors.
If you don't provide a block, the method returns a tuple with `[result_object, error]`

### The CRM Object
A successful request to the Hubspot crm api will result in one or more objects of type `Skiwo::Hubspot::CrmObject`.
Crm objects like `Contact` and `Company` has instance methods for mutating the object on Hubspot.
When working with instances, any errors can be accessed by calling `crm_object.errors`

### Platform ID
A reference from the Skiwo platform record and to the crm object on
Hubspot is set via the custom propertey named `platform_id` on Hubspot.

Example:

- Manymore: Account.id => Hubspot::Contact.platform_id
- Salita: Person.id => Hubspot::Contact.platform_id

Use `Skiwo::Hubspot::Contact.find_by_platform_id(id)` to find the record on Hubspot.

### Find Objects on Hubspot

**Example: Find one contact by the hubspot object id**

```ruby
# With block
contact = Skiwo::Hubspot::Contact.find(hubspot_id) { |error| fail error }
puts contact.email

# Without block
contact, error = Skiwo::Hubspot::Contact.find(hubspot_id)

if error
  fail error
end
puts contact.email
```

### Create an object on Hubspot

**Example: create a new contact on Hubspot**

```ruby
# Note: you can't create two records of the same type
# on Hubspot with the same platform id
contact = Skiwo::Hubspot::Contact.find_by_platform_id(platform_id) { |error| fail error }

unless contact
  attributes = { firstname: "Don", lastname: "Johnson", email: "don@example.com" }
  contact = Skiwo::Hubspot::Contact.create(attributes: attributes) { |error| fail error }
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
can be associated to one or more contacts.

```ruby
company = Skiwo::Hubspot::Company.find(company_id)
contact = Skiwo::Hubspot::Contact.find(contact_id)
association = ContactToCompanyAssociation.new(from_object: contact, to_object: company)

puts association.errors unless association.save

# or
puts contact.errors unless contact.add_company(company)

```

**Create Contact with associated Company in one request**

It is possible to use the property `associatedcompanyid` to associate one company with a contact when the contact is first created. If the company is set on creation it will be labeled as the primary company automatically by Hubspot.

```ruby
company = Skiwo::Hubspot::Company.find_by_platform_id(platform_id) { |error| fail error }
attributes = { 
  firstname: "Don", 
  lastname: "Johnson", 
  email: "don@example.com",  
  associatedcompanyid: company.id 
}

contact = Skiwo::Hubspot::Contact.create(attributes: attributes) { |error| fail error }
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

