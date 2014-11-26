class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]

  # GET /inventories
  # GET /inventories.json
  def index
    @checked_stores = []
    @checked_codes  = []
    if params[:inventory]
      @checked_stores = params[:inventory][:store]
      @checked_stores = params[:inventory][:code]
    end

    @stores      = Inventory.all.collect(&:store).uniq.sort
    @products    = Inventory.all.collect(&:code).uniq.sort

    @inventories = get_selection(params[:inventory])
  end

  def report
    @store   = params[:store] || 0
    @product = params[:code]  || 0

    @inventories = get_selection(params)

    respond_to do |format|
      format.html {}
      format.text { send_data render_to_string('_text_report'), filename: "Store_%s_PRCode_%02d.txt" % [ @store, @product ] }
    end
  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
  end

  # GET /inventories/new
  def new
    @inventory = Inventory.new
  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories
  # POST /inventories.json
  def create
    @inventory = Inventory.new(inventory_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: 'Inventory was successfully created.' }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # Get /inventories/import
  def bulk
    @inventory = Inventory.new
    @status = InventoryStatus.new
  end

  # POST /inventories/import
  def bulk_import
    @inventory = Inventory.new
    @status = Inventory.bulk_import(params[:inventory][:bulk])

    render :bulk
  end

  # PATCH/PUT /inventories/1
  # PATCH/PUT /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to inventories_path, notice: 'Inventory was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.json
  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_path, notice: 'Inventory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def clear
    Inventory.all.destroy_all
    redirect_to inventories_path, notice: 'All Records have been Cleared!'
  end

  def get_selection(params = {})
    inv = Inventory.all

    if params.kind_of?(Hash)
      [:store, :roll, :code].each do |item|
        params.delete(item) if params.has_key?(item) and
            params[item].blank? or
            ( params[item].kind_of?(Array) and params[item][0].blank? )
      end

      inv = inv.where(store: params[:store]) if params.has_key?(:store)
      inv = inv.where(code:  params[:code] ) if params.has_key?(:code)
      inv = inv.where('roll LIKE ?', '%' + params[:roll].upcase + '%' ) if params.has_key?(:roll)
    end

    inv.order(:store, :code, :created_at)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:bulk, :product, :store, :code, :roll, :width, :feet, :inches)
    end
end
