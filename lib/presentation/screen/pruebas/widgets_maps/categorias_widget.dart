import 'package:flutter/material.dart';
import 'package:huehue/presentation/widgets/list/BaseListWidget.dart';

class CategorySelectorWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategorySelectorWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60, // Aumentar la altura para un mejor aspecto
      child: BaseListWidget(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == categories[index]; // Verificar si está seleccionado
          return GestureDetector(
            onTap: () => onCategoryChanged(categories[index]),
            child: Container(
              // margin: const EdgeInsets.symmetric(horizontal: 8), // Espaciado entre los botones
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding vertical para más espacio
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(30), // Mayor radio para esquinas más redondeadas
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5), // Sombra más suave para el botón seleccionado
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null, // Sin sombra si no está seleccionado
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 16, // Tamaño de fuente más grande
                  fontWeight: FontWeight.bold, // Negrita para mejor visibilidad
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
