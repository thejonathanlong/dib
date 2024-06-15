//
//  ItemsListFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import Foundation
import PoCampo

@Reducer
struct ItemsListFeature {

    @Dependency(\.itemCreationService) var itemCreationService
    @Dependency(\.widgetCreationService) var widgetCreationService
    @Dependency(\.itemFetchingStream) var itemFetchingStream

    @ObservableState
    struct State {
        var items: [TrackedItemModel]
        @Presents var itemDetails: ItemFeature.State?
        @Presents var addItem: AddItemFeature.State?
        var stream: AsyncThrowingStream<[TrackedItemModel], Error>?
    }

    enum Action {
        case itemDetails(PresentationAction<ItemFeature.Action>)
        case itemTapped(item: TrackedItemModel)
        case addItemTapped
        case addItem(PresentationAction<AddItemFeature.Action>)
        case fetchItems
        case updateItems([TrackedItemModel])
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .itemTapped(item: item):
                state.itemDetails = .init(item: item)
                return .none

            case .itemDetails:
                return .none

            case .updateItems(let items):
                state.items = items
                return .none

            case .fetchItems:
                return .run { send in
                    for try await items in itemFetchingStream.streamItems() {
                        await send(.updateItems(items))
                    }
                }

            case .addItemTapped:
                state.addItem = .init()
                return .none

            case .addItem(let action):
                switch action {
                case .dismiss:
                    return .none

                case .presented(let addItemAction):
                    switch addItemAction {
                    case .createItem:
                        guard let addItemState = state.addItem else { return .none }

                        let uniqueId = UUID().uuidString
                        let selectedWidgetType = addItemState.widgetTypeSelectionState.selectedOption
                        let widgetType: WidgetModel.WidgetType

                        switch selectedWidgetType {
                        case .textOnly:
                            widgetType = .textOnly(TextOnlyWidgetModel(uniqueId: uniqueId))
                        case .counter:
                            widgetType = .counter(CounterWidgetModel(uniqueId: uniqueId,
                                                                     incrementValue: addItemState.counterOptionsState.incrementValueSelectionState.selectedOption.rawValue,
                                                                     measurement: addItemState.counterOptionsState.itemMeasurementSelectionState.selectedOption))
                        case .bookCounter:
                            widgetType = .bookCounter(.init(uniqueId: uniqueId, title: "", author: ""))
                        }

                        let widget = WidgetModel(uniqueId: uniqueId, type: widgetType)
                        let name = addItemState.nameSelectionState.name
                        let color = addItemState.colorSelectionState.selectedOption

                        state.addItem = nil
                        return .run { _ in
                            let widgetModel = try await self.widgetCreationService.createWidget(widgetModel: widget)
                            let _ = try await self.itemCreationService.createItem(name: name,
                                                                                  color: color,
                                                                                  widgetModel: widgetModel)
                        }
                        
                    case .cancel:
                        state.addItem = nil
                        return .none

                    default:
                        return .none
                    }
                }
            }
        }
        .ifLet(\.$itemDetails, action: \.itemDetails) {
            ItemFeature()
        }
        .ifLet(\.$addItem, action: \.addItem) {
            AddItemFeature()
        }
    }
}

