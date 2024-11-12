class Utilisateur {
  int id;
  String? role;
  String? nom;
  String? prenom;
  String? photo;
  DateTime? dateDeNaissance;
  String email;
  String motDePasse;
  String? rue;
  String? codePostal;
  String? commune;
  String? pays;
  int? point;

  Utilisateur({
    required this.id,
    this.role,
    this.nom,
    this.prenom,
    this.photo,
    this.dateDeNaissance,
    required this.email,
    required this.motDePasse,
    this.rue,
    this.codePostal,
    this.commune,
    this.pays,
    this.point,
  });

  // Méthode pour convertir un JSON en instance de Utilisateur
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      role: json['role'],
      nom: json['nom'],
      prenom: json['prenom'],
      photo: json['photo'],
      dateDeNaissance: json['date_de_naissance'] != null
          ? DateTime.parse(json['date_de_naissance'])
          : null,
      email: json['email'],
      motDePasse: json['mot_de_passe'],
      rue: json['rue'],
      codePostal: json['code_postal'],
      commune: json['commune'],
      pays: json['pays'],
      point: json['point'],
    );
  }

  // Méthode pour convertir une instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'nom': nom,
      'prenom': prenom,
      'photo': photo,
      'date_de_naissance': dateDeNaissance?.toIso8601String(),
      'email': email,
      'mot_de_passe': motDePasse,
      'rue': rue,
      'code_postal': codePostal,
      'commune': commune,
      'pays': pays,
      'point': point,
    };
  }
}
