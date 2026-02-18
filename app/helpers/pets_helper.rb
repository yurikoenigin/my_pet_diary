module PetsHelper
  def gender_class(gender)
    case gender
    when "male"
      "bg-blue-100 text-blue-700"
    when "female"
      "bg-pink-100 text-pink-700"
    else
      "bg-gray-100 text-gray-700"
    end
  end
end
