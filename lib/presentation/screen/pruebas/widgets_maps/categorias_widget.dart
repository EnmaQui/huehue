import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/widgets/list/BaseListWidget.dart';

class CategorySelectorWidget extends StatelessWidget {
  final List<String> categories;

  const CategorySelectorWidget({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final placeBloc = context.read<PlaceBloc>();
    return SizedBox(
      height: 60, // Aumentar la altura para un mejor aspecto
      child: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) {
          return BaseListWidget(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              final isSelected = state.selectedCategory ==
                  categories[index]; // Verificar si está seleccionado
              return GestureDetector(
                onTap: () {
                  placeBloc.add(SetSelectedCategory(category: categories[index]));
                },
                child: Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 8), // Espaciado entre los botones
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // Padding vertical para más espacio
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : null,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(
                        30), // Mayor radio para esquinas más redondeadas
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(
                                  0.5), // Sombra más suave para el botón seleccionado
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null, // Sin sombra si no está seleccionado
                  ),
                  child: Text(
                    categories[index],
                    style: const TextStyle(
                      fontSize: 16, // Tamaño de fuente más grande
                      fontWeight:
                          FontWeight.bold, // Negrita para mejor visibilidad
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
