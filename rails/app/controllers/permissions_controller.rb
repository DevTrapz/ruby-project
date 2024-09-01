class PermissionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_permission, only: %i[ show edit update destroy ]

  # GET /permissions or /permissions.json
  def index
    @permissions = Permission.all
  end

  # GET /permissions/1 or /permissions/1.json
  def show
  end

  # GET /permissions/new
  def new
    byebug
    @permission = Permission.new
  end

  # GET /permissions/1/edit
  def edit
  end

  # POST /permissions or /permissions.json
  def create
    # Request:
    # { 
    #   "permission": 
    #     {
    #       "permission_type": string,
    #       "user_id": number
    #     }
    # }
    permission = params[:permission].permit(:user_id,:permission_type)
    @permission = Permission.new(permission)

    respond_to do |format|
      if @permission.save
        format.html { redirect_to permission_url(@permission), notice: "Permission was successfully created." }
        format.json { render :show, status: :created, location: @permission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permissions/1 or /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html { redirect_to permission_url(@permission), notice: "Permission was successfully updated." }
        format.json { render :show, status: :ok, location: @permission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1 or /permissions/1.json
  def destroy
    @permission.destroy!

    respond_to do |format|
      format.html { redirect_to permissions_url, notice: "Permission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def permission_params
      params.require(:permission).permit(:id, :permission_type)
    end
end
