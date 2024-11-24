resource random_integer name {
  min = 20
  max = 350

    lifecycle{
        #create_before_destroy = true
        #prevent_destroy = true
        ignore_changes = [min, max]
    }

}

# •	create_before_destroy = true
# 	•	Terraform najpierw utworzyłby nowy zasób, a dopiero potem usunąłby poprzedni. Przydatne w przypadku, gdy nie chcemy, aby w systemie były przerwy między starą i nową wersją zasobu.
# 	•	prevent_destroy = true
# 	•	Zapobiegnie to usunięciu zasobu. Terraform nie usunie tego zasobu, nawet jeśli zostanie to zadeklarowane w planie. Może być to przydatne w sytuacjach, gdy nie chcemy przypadkowo usunąć zasobu.

	# •	min i max kontrolują zakres liczby losowej.
	# •	lifecycle pozwala dostosować sposób zarządzania tym zasobem w trakcie cyklu życia. ignore_changes pozwala ignorować zmiany w parametrach min i max, co zapobiega usuwaniu i tworzeniu zasobu po ich zmianie.