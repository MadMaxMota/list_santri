# 📦 Santri App - Gerenciador de Produtos

Um aplicativo Flutter para Android que permite aos usuários cadastrar, listar e ordenar produtos. O projeto foi construído aplicando rigorosamente os princípios de **Clean Architecture**, **SOLID** e **Clean Code**, com destaque para a implementação de um **algoritmo de ordenação próprio (Quick Sort)** e um **sistema de caching local**.

---

## 📌 Índice
1. [Sobre o Projeto](#-sobre-o-projeto)
2. [Tecnologias Utilizadas](#-tecnologias-utilizadas)
3. [Arquitetura e Estrutura de Pastas](#-arquitetura-e-estrutura-de-pastas)
4. [Fluxo da Aplicação (Data Flow)](#-fluxo-da-aplicação-data-flow)
5. [Destaques Técnicos](#-destaques-técnicos)
6. [Como Executar o Projeto](#-como-executar-o-projeto)

---

## 📖 Sobre o Projeto

O objetivo deste aplicativo é permitir que os usuários gerenciem uma lista de produtos contendo **Nome**, **Preço de Compra** e **Preço de Venda**.

**Requisitos atendidos (de acordo com o escopo da task):**
- [x] Cadastro de produtos (Nome, Preço de Compra, Preço de Venda).
- [x] Listagem paginada de produtos (Scroll infinito).
- [x] Ordenação customizada por: Nome, Preço de Compra e Preço de Venda.
- [x] **Utilização máxima de algoritmo próprio:** Implementação manual do algoritmo Quick Sort, sem uso do `.sort()` nativo do Dart.
- [x] **Sistema de Caching Local:** Produtos são cacheados localmente para proporcionar tempos de carregamento mais rápidos e suporte offline-first.
- [x] Feedback visual de loading (Overlay durante o cadastro).
- [x] Tratamento de erros amigável (Snackbars e Empty States).

---

## 🚀 Tecnologias Utilizadas

*   **Flutter** & **Dart**
*   **Flutter BLoC (Cubit)** para gerenciamento de estado reativo.
*   **Clean Architecture** (separação em camadas: Data, Domain, Presentation).
*   **UUID** para geração de identificadores únicos.
*   **SOLID** e **Clean Code** para um código de fácil manutenção e testabilidade.

---

## 🏗️ Arquitetura e Estrutura de Pastas

O projeto está dividido em três camadas principais, garantindo o desacoplamento e a testabilidade:

*   **Domain:** Regras de negócio puras (Entidades, Casos de Uso, Contratos). Não depende de frameworks.
*   **Data:** Implementação de repositórios, sistema de caching e fontes de dados.
*   **Presentation:** Interface do usuário (UI) e gerenciamento de estado (Cubits).

### 📂 Estrutura de Pastas

```text
lib/
├── data/                          # Camada de Dados
│   ├── datasources/               # Fontes de dados
│   │   ├── local/                 # Armazenamento local (ex: SharedPreferences/SQLite)
│   │   └── cache/                 # 🆕 Implementação do Sistema de Caching
│   └── repositories/              # Implementação dos Repositórios (Lida com a lógica de cache)
│
├── domain/                        # Camada de Domínio (Regras de Negócio)
│   ├── entities/                  # Entidades (ProductEntity)
│   ├── repositories/              # Contratos/Abstrações dos Repositórios
│   └── usecases/                  # Casos de Uso
│       ├── add_product_use_case.dart
│       ├── get_products_use_case.dart
│       └── sort_products_use_case.dart  <-- 🧠 Algoritmo Quick Sort Próprio
│
└── presentation/                  # Camada de Apresentação (UI/Estado)
    ├── bloc/                      # Gerenciamento de Estado (Cubit e States)
    │   └── products_cubit.dart
    └── ui/                        # Interface do Usuário
        ├── add_product/           # Tela de Cadastro
        │   ├── pages/
        │   └── widgets/
        └── products_list/         # Tela de Listagem
            ├── pages/
            └── widgets/


[👤 Usuário]
     │
     ▼ (Interage com a tela)
[🖥️ UI - ProductsPage]
     │
     ▼ (Dispara evento: loadInitialProducts)
[🧠 Cubit - ProductsCubit]
     │
     ▼ (Chama o Caso de Uso)
[⚙️ Domain - GetProductsUseCase]
     │
     ▼ (Chama a abstração do Repositório)
[📦 Data - ProductRepository]
     │
     ├──> 📦 Verifica o Cache (ProductCacheDataSource)
     │
     ├──> (Cache Hit) ──> Retorna Lista em Cache
     │
     └──> (Cache Miss) ──> 💾 Busca na Fonte de Dados Local
                          │
                          ├──> Salva no Cache
                          │
                          └──> Retorna List<ProductEntity>
     │
     ▲ (Retorna EitherOf<Failure, PaginatedResponse>)
[⚙️ Domain - GetProductsUseCase]
     │
     ▲ (Retorna dados para o Cubit)
[🧠 Cubit - ProductsCubit]
     │
     ├──> 🧠 Aplica SortProductsUseCase (Algoritmo Quick Sort Próprio)
     │
     ▼ (Emite novo estado: ProductsLoaded)
[🖥️ UI - BlocBuilder]
     │
     ▼ (Reconstrói a tela com a lista ordenada)
[👤 Usuário] (Visualiza a lista atualizada)            
