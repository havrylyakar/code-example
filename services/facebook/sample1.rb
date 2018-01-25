module Facebook
  class UserService
    attr_reader :token, :object, :errors

    def initialize(token)
      @token = token
      @object = 'me'
      @errors = []
    end

    def graph
      @graph ||= Koala::Facebook::API.new(token)
    end

    def attributes
      {
        avatar: profile_picture,
        full_name: name,
        email: email,
        facebook_id: id,
        facebook_friends_ids: friends_ids,
        facebook_user_token: token
      }
    end

    def friends_ids
      friends.map { |el| el['id'] }
    end

    def friends
      @friends ||= graph.get_connections(object, 'friends')
    end

    def self.koala_user_attributes
      %w(name email id)
    end

    private

    koala_user_attributes.each do |attribute|
      define_method attribute.to_s do
        response_object[attribute]
      end
    end

    def profile_picture
      URI.parse(graph.get_picture(object, type: 'large'))
    end

    def response_fields
      self.class.koala_user_attributes.join(', ')
    end

    def response_object
      @response_object ||= graph.get_object(object, fields: response_fields)
    end
  end
end
