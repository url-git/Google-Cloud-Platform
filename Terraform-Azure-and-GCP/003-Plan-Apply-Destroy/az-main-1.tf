# określenie, co należy zrobić, aby rzeczywista konfiguracja zasobów w Azure była taka sama jak w pliku tf
terraform plan

# zastosowanie konfiguracji opisanej w pliku tf względem Azure
terraform apply

# usunięcie infrastruktury, którą zarządza Terraform
terraform destroy

terraform –help
terraform plan –help

# 	1.	terraform plan –out=./changes.tfplan:
# 	•	Generuje plan zmian, zapisuje go do pliku, ale nie wprowadza żadnych zmian w chmurze.
# 	2.	terraform apply –auto-approve ./changes.tfplan:
# 	•	Wykonuje zmiany w chmurze zgodnie z wcześniej zapisanym planem, automatycznie zatwierdzając wszystkie zmiany bez interakcji użytkownika.

# Ten proces jest przydatny, kiedy chcesz mieć pełną kontrolę nad tym, jakie zmiany będą wprowadzone, ale chcesz uniknąć interakcji podczas samego wdrożenia.

terraform plan –out=./changes.tfplan # Np. aby stworzyć plan i zapisać go w pliku uruchom
terraform apply –auto-approve ./changes.tfplan # Mając taki plan, można go wykonać poleceniem
terraform apply –destroy # Kiedy zasoby nie są już potrzebne, można je zniszczyć poleceniem