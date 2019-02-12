class CasesController < ApplicationController
    before_action :find_case, only:[:show, :edit, :update, :destroy]
    before_action :get_organization, only:[:index, :create, :show, :update, :destroy]
    before_action :get_categories, only:[:new, :create, :edit]

    def index
        @cases = Case.all.order("created_at DESC").where({organization_id: @org.id})
    end

    def new
        @case = current_user.case.build
    end

    def create
        @case = current_user.case.build(case_params)
        puts "**************\n"*19
        puts case_params.inspect
        @case.category_id = params[:case][:category_id]
        instances =  Case.where(category_id: params[:case][:category_id]).count + 1
        @case.organization_id = @org.id
        @case.title = Category.find(params[:case][:category_id]).name + "-" + instances.to_s

        if @case.save
            redirect_to root_path
        else
            render 'new'
        end
    end
    
    def show
        @case = Case.find(params[:id])
    end

    def edit; end

    def update
        @case.category_id = params[:case][:category_id]
        if @case.update(case_params)
            redirect_to case_path(@case)
        else
            render 'edit'
        end
    end

    def destroy
        @case.destroy
        redirect_to root_path   #route back
    end 

    private 
    def case_params
        params.require(:case).permit(:name, :address, :contact, :cnic, :verifierPreference, :description, :category_id, :files)
    end

    def find_case
        @case = Case.find(params[:id])
    end

    def get_organization
        @org = Organization.with_roles([:admin, :user], current_user).first
    end

    def get_categories
    @categories = Category.pluck(:name, :id)
    end

end
