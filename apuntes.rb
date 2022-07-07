class User < ApplicationRecord
  include BCrypt 
     # Valida que, al crear un registro, este tenga un valor para la # columna email, y que además cada email sea único, sin importar # mayusculas o minusculas, o sea, que no pueda registrarme  
     # con “hola@gmail.com” y “hOlA@Gmail.cOM” 
     validates :email, presence: true, uniqueness: { case_sensitive: false } 
            # Validamos que haya un password 
     validates :password_present?

     def password # evita dar error al cuando no hay un password_digest 
        return nil unless password_digest.present? 
        # Crea un objeto BCrypt::Password a partir del valor # de la columna password_digest de nuestro user. # Este valor debe ser un password hasheado creada anteriormente por # BCrypt a través de Password.create, o el método fallará # Ejemplo: # > BCrypt::Password.new('unvalor') #   Traceback (most recent call last): #   2: from (irb):29 #   1: from (irb):29:in `new' #   BCrypt::Errors::InvalidHash (invalid hash) # # pero usando un hash generado por BCrypt::Password.create # # hash = "$2a$12$axdTlmaUVAtyJPY8TYI.QOZNTs8NHA3O1RCg5FqEnThU2c31887TG" #  objeto_password = BCrypt::Password.new(hash) #  # => "$2a$12$axdTlmaUVAtyJPY8TYI.QOZNTs8NHA3O1RCg5FqEnThU2c31887TG" #  > objeto_password.class # => BCrypt::Password # Nota: Si quieres probar este código, pruébalo en tu propio # computador con tus propios valores, puesto que los de este ejemplo # podrían no ser válidos en tu caso 
        @password ||= Password.new(password_digest)
     end 

     def password=(new_password) 
        # Crea un nuevo objeto password tomando como base un string “normal” # (no un string hasheado como Password.new) # Ejemplo: # pw = BCrypt::Password.create('mipassword') # => "$2a$12$WLekjNomW9sxkltKBIHUFuNshcQEM91cK5IEHdOj0RqRg3xcbBd8G" # pw.class # => BCrypt::Password
      # y luego este password creado (en nuestro caso, la variable pw, # en el caso del método, @password) # se asigna al atributo ‘password_digest’ del objeto, para que al # ejecutar el método #save del user al que estamos asignando # password se almacene nuestro password hasheado en la columna # password_digest del registro en la base de datos 
      @password = Password.create(new_password) 
      self.password_digest = @password 
     end  
     
     def authenticate(unencrypted_password) 
        # Llama a nuestro método de instancia password, el cual extrae el # password_digest del user desde la base de datos, lo transforma # a un objeto BCrypt::Password, el cual entre sus metodos # tiene a is_password?, el cual nos permite tomar una string # no encriptada y verificar si el password_digest corresponde # a esta string no encriptada, es decir: # "$2a$12$axdTlmaUVAtyJPY8TYI.QOZNTs8NHA3O1RCg5FqEnThU2c31887TG" # corresponde a ‘mipass’? (o el valor que venga en el parámetro # unencrypted_password), y de ser así, devuelve self, es decir, # el usuario que estamos tratando de autenticar (debido # a que estamos en un método de instancia de user, self es la # instancia de User) 
        password.is_password?(unencrypted_password) && self 
     end
     
     def password_present? # Usado para nuestra validación 
        errors.add(:password, :blank) unless password.present? 
     end

    end
