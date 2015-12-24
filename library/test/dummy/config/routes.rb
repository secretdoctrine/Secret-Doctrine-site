Rails.application.routes.draw do

  mount Library::Engine => "/library"
end
