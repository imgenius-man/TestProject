class UserMailer < ApplicationMailer
    def welcome_email(email)
        @email = email
        @url  = 'http://localhost:3000/'
        mail(to: email, subject: 'Welcome to My Awesome Site, Yabloi!')
    end
end