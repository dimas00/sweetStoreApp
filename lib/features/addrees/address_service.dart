import 'package:flutter/material.dart';
import 'package:sweet_store/core/network/api_client.dart';

class AddressService {

  static final api = ApiClient();
  // 🔥 Agora guarda uma LISTA de endereços
  static final ValueNotifier<List<Map<String, dynamic>>> addresses = ValueNotifier([]);

  static Future<void> fetchAddresses() async {
    try {
      // Faz a requisição GET para o endpoint de endereços
      final response = await api.get("/endereco");

      // O seu ApiClient já trata erros e retorna o body decodificado
      // A estrutura do seu Java coloca os dados na chave "data"
      if (response != null && response["data"] != null) {
        final List<dynamic> listaBruta = response["data"];

        // Converte a lista dinâmica para o formato esperado e atualiza o ValueNotifier
        addresses.value = listaBruta.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print("Erro ao carregar endereços: $e");
    }
  }

  static void addAddress(Map<String, dynamic> newAddress) {
    // Se for o primeiro endereço, já define como padrão automaticamente
    if (addresses.value.isEmpty) {
      newAddress['padrao'] = true;
    } else if (newAddress['padrao'] == true) {
      _removerPadraoAtual();
    }

    // Geramos um ID falso localmente para conseguir editar/excluir (no futuro virá do backend)
    newAddress['id'] = DateTime.now().millisecondsSinceEpoch.toString();

    // Atualiza a lista
    addresses.value = [...addresses.value, newAddress];
  }

  static void updateAddress(String id, Map<String, dynamic> updatedAddress) {
    if (updatedAddress['padrao'] == true) {
      _removerPadraoAtual();
    }

    final newList = addresses.value.map((e) {
      if (e['id'] == id) return updatedAddress;
      return e;
    }).toList();

    addresses.value = newList;
  }

  static void removeAddress(String id) {
    addresses.value = addresses.value.where((e) => e['id'] != id).toList();
  }

  static void setAsDefault(String id) {
    final newList = addresses.value.map((e) {
      return {...e, 'padrao': e['id'] == id}; // Só fica true se for o id escolhido
    }).toList();

    addresses.value = newList;
  }

  static void _removerPadraoAtual() {
    // Tira o "padrao = true" do endereço que estava marcado
    addresses.value = addresses.value.map((e) => {...e, 'padrao': false}).toList();
  }


  static bool hasAddress() {
    return addresses.value != null;
  }
}