//
//  EventDetailViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/26/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    var event: CalendarEvent?
    let originalEvent: CalendarEvent?
    let eventController: CalendarEventController
    
    func enabledColor() -> UIColor { isEditing ? .clear : .systemGray4 }
    
    lazy var statusTextFieldDelegate = EmptyStatusTextFieldDelegate(textFields: [titleTextField])
    
    lazy var titleTextField: StatusTextField<EmptyStatusTextFieldDelegate> = {
        let textField = StatusTextField<EmptyStatusTextFieldDelegate>(textFieldType: .empty,  type:.information, exampleText: "Enter Event Title", textFieldPlaceholderText: "Enter Event Title", instructionText: nil)
        textField.text = event?.title
        return textField
    }()
    
    lazy var notesTextView: UITextView = {
        let textView = UITextView.borderedTextView()
        textView.backgroundColor = enabledColor()
        textView.isUserInteractionEnabled = isEditing
        textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        textView.text = event?.notes
        return textView
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView.componentStack(elements: [titleTextField, notesTextView], spacing: 30)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(eventController: CalendarEventController, editMode: Bool = true, event: CalendarEvent? = nil) {
        self.eventController = eventController
        self.originalEvent = event
        super.init(nibName: nil, bundle: nil)
        self.event = event
        self.isEditing = editMode
        titleTextField.statusTextFieldDelegate = statusTextFieldDelegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEvent))
        return button
    }()
    
    @objc private func saveEvent() {
        // if originalEvent is nil, make a new event
        // otherwise, check if current event has changes and update if it does
        // TODO: Duration, Date
        if originalEvent == nil {
            if let text = titleTextField.text,
               !text.isEmpty {
                event = CalendarEvent(id: UUID(), title: text, notes: notesTextView.text, date: Date(), duration: 0)
                eventController.saveEvent(event!)
            }
            return
        }
        
        if let event = event {
            if let text = titleTextField.text,
               !text.isEmpty {
                self.event = CalendarEvent(id: event.id, title: text, notes: notesTextView.text, date: event.date, duration: event.duration)
                if originalEvent != self.event {
                    eventController.saveEvent(self.event!)
                }
            }
            isEditing.toggle()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        constraints()
    }
    
    private func constraints() {
        let spacing: CGFloat = 20
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing)
        ])
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        toggleView(titleTextField, editing: editing)
        toggleView(notesTextView, editing: editing)
        if editing {
            navigationItem.rightBarButtonItem = saveButton
        } else {
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }
    
    private func toggleView(_ view: UIView, editing: Bool) {
        view.backgroundColor = enabledColor()
        view.isUserInteractionEnabled = editing
    }
}

