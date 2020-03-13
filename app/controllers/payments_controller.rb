class PaymentsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:webhook]
    #this line is used for auth purposes with the webhook

    def success

    end

    def webhook
            event = Stripe::Event.construct_from(
            params.to_unsafe_h
        )
    
        # Handle the event
        case event.type
        when 'payment_intent.succeeded'
            payment_intent = event.data.object # contains a Stripe::PaymentIntent
            
            buyer = User.find(payment_intent.metadata.user_id)
            listing = Track.find(payment_intent.metadata.track_id)
            # These 2 lines are looking for the user and track in their respective tables.
            listing.total_donations += 1
            # adding to the total_donations column of the Track model
            listing.save
            # Saving the change in the line above
            buyer.donations << listing
            # this line is pushing the track and making the relation in the join table. A user has_many :donations through :track_donations. This line relates to the User model which can be checke for verification.
            buyer.save
            #saving the change
            trackdonation = TrackDonation.last
            #After all of the above code has run, look for the last transaction.
            trackdonation.value += 1
            #This changes the value of the non-linked item in the join table: the value column. This increases the value of said column by 1. This is default as all donations are made in 1 dollar increments. In future developments this could be referenced in a different way.
            trackdonation.save
            #saving the change

        when 'payment_method.attached'
            payment_method = event.data.object # contains a Stripe::PaymentMethod
            # Then define and call a method to handle the successful attachment of a PaymentMethod.
        else
            # Unexpected event type
            # render :nothing => true, :status => :bad_request
            p event.type
            render body: nil, status: 200
            return
        end
        # success, but don't need to send anything back to Stripe
        head :no_content
      end

end