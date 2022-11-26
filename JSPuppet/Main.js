// This would ideally be typescript.

Helpers = {
    addButton: function(bridge, id, title, leadingAnchor, trailingAnchor, topAnchor, cornerRadius, onTap) {
        bridge({
            action: "addSubview",
            id: id,
            type: "button",
            title: title,
            leadingAnchor: leadingAnchor,
            trailingAnchor: trailingAnchor,
            topAnchor: topAnchor,
            cornerRadius: cornerRadius,
            onTap: onTap,
        })
    },
    // Style can be 'actionSheet' or anything else for an alert.
    presentAlert: function(bridge, title, message, style) {
        bridge({
            action: "presentAlert",
            title: title,
            message: message,
            style: style,
        })
    },
}

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes
class HomeViewController {
    bridge;
    foo = 0;
    constructor(bridge, foo) {
        //throw new Error("In constructor!")
        this.bridge = bridge // I like this not being global.
        this.foo = foo
    }
    viewDidLoad() {
        const myThis = this
        Helpers.addButton(this.bridge, "hello1", "Add 1", 24, -24, 100, 8, () => {
            myThis.foo = myThis.foo + 1
        })
        Helpers.addButton(this.bridge, "hello2", "Add 2", 24, -24, 200, 8, () => {
            myThis.foo = myThis.foo + 2
        })
        Helpers.addButton(this.bridge, "hello3", "What is it?", 24, -24, 300, 8, () => {
            Helpers.presentAlert(myThis.bridge, "Sum", `Now is: ${myThis.foo}`)
        })
    }
}
