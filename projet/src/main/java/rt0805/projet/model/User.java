package rt0805.projet.model;


public class User {
    private int id;
    private String email;


    public User(int id, String email) {
        this.id = id;
        this.email = email;

    }

    public int getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }


}