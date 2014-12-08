require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      
      before { ActionMailer::Base.deliveries = [] }

      it "create an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "John Doe", recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(Invitation.count).to eq(1)
      end
      it "sends an email to recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "John Doe", recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
      it "redirects to the invitation new page" do
        set_current_user
        post :create, invitation: { recipient_name: "John Doe", recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(response).to redirect_to new_invitation_path
      end
      it "sets a flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "John Doe", recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(flash[:success]).to be
      end
    end
    
    context "with invalid inputs" do

      before { ActionMailer::Base.deliveries = [] }

      it "renders the new template" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(response).to render_template :new
      end
      it "sets the flash error message" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(flash[:danger]).to be
      end
      it "does not create the invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(Invitation.count).to eq(0)
      end
      it "does not send out an email" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "sets @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Bro, this is a dope site!" }
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end