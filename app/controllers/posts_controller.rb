require 'csv'
class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @posts = Post.includes(:categories, :user, :region, :province, :city, :barangay).page(params[:page]).per(5).all
  end

  def show
  end

  def short_url_redirect
    @post = Post.find_by(short_url: params[:short_url])

    if @post
      redirect_to post_path(@post), status: :moved_permanently
    else
      render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
    end
  end

  def new
    @post = Post.new
  end

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if Rails.env.development?
      @post.ip_address = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      @post.ip_address = request.remote_ip
    end
    
    if @post.save
      flash[:notice] = 'Post created successfully'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @post, :update?, policy_class: PostPolicy
    if @post.update(post_params)
      flash[:notice] = 'Post updated successfully'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy
    @post.destroy
    'Post destroyed successfully'
    redirect_to posts_path
  end

#create and new method for importing csv
  def import_new; end

  def import_create
    if params[:file].present?
      process_csv_file(params[:file])
      flash[:notice] = 'CSV data imported successfully!'
      redirect_to posts_path
    else
      redirect_to posts_path, alert: 'Please select a CSV file to import.'
    end
  end
  
# method for exporting csv
  def export_to_csv
    data = Address::Region.includes(provinces: { cities: :barangays })
    csv_data = CSV.generate do |csv|
      data.each do |region|
        csv << ["Region: #{region.name}"]

        region.provinces.each do |province|
          csv << ["Province: #{province.name}"]

          province.cities.each do |city|
            csv << ["City: #{city.name}"]

            city.barangays.each do |barangay|
              csv << ["Barangay: #{barangay.name}"]
            end
          end
        end
      end 
    end
    send_data csv_data, filename: 'philippine_data.csv'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def process_csv_file(file)
    CSV.foreach(file.path) do |row|
  
    end
  end

  def post_params
    params.require(:post).permit(:title, :content, :address, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id, :page, category_ids: [])
  end
end
