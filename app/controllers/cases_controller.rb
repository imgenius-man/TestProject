class CasesController < ApplicationController
    before_action :find_case, only:[:show, :edit, :update,:destroy]

    def index
        @cases = Case.all.order("created_at DESC")
    end

    def new
        @case = current_user.case.build
        #@case = Case.new
        @categories = Category.all.map { |c| [c.name,c.id] }
    end

    def create
        @case = current_user.case.build(case_params)
        @case.category_id = params[:category_id]
        #@case = Case.new(case_params)
        if @case.save
            redirect_to root_path
        else
            render 'new'
        end
    end
    
    def show
        
    end

    def edit
        @categories = Category.all.map { |c| [c.name,c.id] }
    end

    def update
        @case.category_id = params[:category_id]
        if @case.update(case_params)
            redirect_to case_path(@case)
        else
            render 'edit'
        end
    end

    def destroy
        @case.destroy
        redirect_to root_path
    end 

    private 
    def case_params
        params.require(:case).permit(:description, :category_id)
    end

    def find_case
        @case = Case.find(params[:id])
    end


end
