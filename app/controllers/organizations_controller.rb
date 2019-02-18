class OrganizationsController < ApplicationController
    before_action :validate_superAdmin
    before_action :find_org, only: [:show, :destroy, :edit, :update]

    def index
        @orgs = Organization.all.order("created_at DESC")
    end
    def new
        @org = Organization.new
    end

    def create
        OrganizationCreator.new(org_params).perform
        redirect_to organizations_path
    end

    def edit; end
    
    def update
        @org.update!(org_params.except(:email, :password))
        if org_params[:email].present?
            @org.update_admin(@admin.first.id, org_params[:email])
        end
    end

    def show; end

    def destroy
        User.with_role(:admin, @org).destroy_all
        User.with_role(:user, @org).destroy_all
        @org.destroy
        redirect_to organizations_path
    end


    private 
    def org_params
        # generated_password = Devise.friendly_token.first(8)
        params[:organization][:password]= '112233'
        params.require(:organization).permit(:title, :email, :password)
    end

    def find_org
        @org = Organization.find(params[:id])
        @admin = User.with_role(:admin ,@org)
    end

    def validate_superAdmin
        return true if current_user.has_role?(:super)
        redirect_to root_path
        flash[:notice] = 'Get the *uck Outta Here!'
    end

end
